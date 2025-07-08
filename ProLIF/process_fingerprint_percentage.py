import os
import csv
import re
import argparse

def is_file_empty(file_path):
    """Check if a file is empty."""
    return os.path.exists(file_path) and os.stat(file_path).st_size == 0

def separate_interactions(input_file, base_directory):
    """Separates the interactions and generates organized CSV and TXT files."""
    if is_file_empty(input_file):
        print(f"Error: The input file '{input_file}' is empty.")
        return

    output_files = {}

    # Read the input file and get the names of output files
    try:
        with open(input_file, 'r') as file:
            csv_reader = csv.reader(file)
            headers = next(csv_reader)  # Skip first row
            next(csv_reader)  # Skip second row
            interaction_types = next(csv_reader)
    except FileNotFoundError:
        print(f"Error: The input file '{input_file}' was not found.")
        return
    except Exception as e:
        print(f"Error reading input file '{input_file}': {e}")
        return

    # Generate unique names for the output files
    for interaction_type in interaction_types[1:]:
        base_name = interaction_type.lower().replace(" ", "_")
        file_name = base_name + ".csv"
        output_files[interaction_type] = file_name

    # Process each interaction type
    for interaction_type, output_file in output_files.items():
        try:
            # Create folder for the interaction type
            interaction_folder = os.path.join(base_directory, interaction_type)
            os.makedirs(interaction_folder, exist_ok=True)

            # File paths
            csv_output_path = os.path.join(interaction_folder, output_file)
            txt_output_path = os.path.join(interaction_folder, interaction_type + ".txt")
            processed_txt_path = os.path.join(interaction_folder, interaction_type + "_processed.txt")

            label_columns = []

            # Get indices of columns corresponding to the interaction type
            with open(input_file, 'r') as file:
                csv_reader = csv.reader(file)
                headers = next(csv_reader)
                for row in csv_reader:
                    if interaction_type in row:
                        label_columns.extend(i for i, value in enumerate(row) if value == interaction_type)

            column_indices = [0] + label_columns

            # Write output CSV file
            with open(input_file, 'r') as infile, open(csv_output_path, 'w', newline='') as outfile:
                csv_reader = csv.reader(infile)
                csv_writer = csv.writer(outfile)
                headers = next(csv_reader)
                csv_writer.writerow([headers[i] for i in column_indices])
                for row in csv_reader:
                    output_row = [row[i] for i in column_indices]
                    csv_writer.writerow(output_row)

            print(f"The CSV file for {interaction_type} has been processed successfully.")

            # Convert the CSV file to a text file
            with open(csv_output_path, 'r') as csv_file, open(txt_output_path, 'w') as txt_file:
                csv_reader = csv.reader(csv_file)
                data = list(csv_reader)

                # Remove the first column and the third row
                data_without_column = [row[1:] for row in data]
                data_without_row = data_without_column[:2] + data_without_column[3:]

                # Transpose the data and write to the text file
                for row in zip(*data_without_row):
                    txt_file.write('\t'.join(row) + '\n')

            print(f"The TXT file for {interaction_type} has been generated successfully.")

            # Process the generated text file
            with open(txt_output_path, 'r') as f_input, open(processed_txt_path, 'w') as f_output:
                for line in f_input:
                    parts = line.split('\t')
                    parts[1] = ''.join(c for c in parts[1] if not c.isdigit())
                    f_output.write('\t'.join(parts))

            print(f"The processed TXT file for {interaction_type} has been generated successfully.")
        except Exception as e:
            print(f"Error processing interaction type '{interaction_type}': {e}")

def get_interactions(aas, lipid, input_file):
    """Function to get interactions and sum them up."""
    interactions = []
    try:
        with open(input_file, 'r') as input_data:
            for line in input_data:
                if aas in line and lipid in line:
                    fields = line.strip().split()
                    interactions.append(fields)
        total_sum = sum(float(entry[2]) for entry in interactions)
        return interactions, total_sum
    except Exception as e:
        print(f"Error getting interactions for {aas} and {lipid} from file '{input_file}': {e}")
        return [], 0.0

def process_interactions(sequence_file, input_file, output_directory, lipid_list):
    """Processes interactions for each amino acid and lipid."""
    if is_file_empty(sequence_file):
        print(f"Error: The sequence file '{sequence_file}' is empty.")
        return

    try:
        # Read amino acid sequence
        with open(sequence_file, 'r') as seq_file:
            sequence = [line.strip() for line in seq_file.readlines()]
    except FileNotFoundError:
        print(f"Error: The sequence file '{sequence_file}' was not found.")
        return
    except Exception as e:
        print(f"Error reading sequence file '{sequence_file}': {e}")
        return

    all_interactions = {aas: {lipid: 0 for lipid in lipid_list} for aas in sequence}

    for lipid in lipid_list:
        interactions_lipid = []

        for aas in sequence:
            interactions, total_sum = get_interactions(aas, lipid, input_file)
            interactions_lipid.append((aas, interactions, total_sum))
            all_interactions[aas][lipid] = total_sum

        try:
            # Write the results to files
            output_file_path = os.path.join(output_directory, f'interactions_ordered_aasVSlipid_{lipid}.out')
            with open(output_file_path, 'w') as out_file:
                for aas, interactions, total_sum in interactions_lipid:
                    out_file.write(f"{aas} {lipid}\n")
                    for entry in interactions:
                        out_file.write(f"{entry}\n")
                    out_file.write(f"sum={total_sum}\n")
        except Exception as e:
            print(f"Error writing results to file for lipid '{lipid}': {e}")

    try:
        # Generate output in columns aas=%occupancy
        total_interactions_path = os.path.join(output_directory, 'total_interactions.csv')
        with open(total_interactions_path, 'w') as out_file:
            out_file.write('Residue,' + ','.join(lipid_list) + '\n')
            for aas in sequence:
                total_sums = [all_interactions[aas][lipid] for lipid in lipid_list]
                out_file.write(f"{aas},{','.join(map(str, total_sums))}\n")
    except Exception as e:
        print(f"Error writing total interactions to CSV file: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Process fingerprint percentage data.")
    parser.add_argument("-if", "--input_file", required=True, help="Name of the input CSV file.")
    parser.add_argument("-sf", "--sequence_file", required=True, help="Name of the sequence file.")
    parser.add_argument("-l", "--lipids", required=True, nargs='+', help="Names of the lipids to process.")
    parser.add_argument("-o", "--output_directory", required=True, help="Name of the base directory for results.")
    args = parser.parse_args()

    if is_file_empty(args.input_file):
        print(f"Error: The input file '{args.input_file}' is empty.")
    else:
        # Step 1: Separate interactions and generate TXT files
        separate_interactions(args.input_file, args.output_directory)

        # Step 2: Process interactions for each amino acid and lipid using the generated TXT files
        for dirpath, dirnames, filenames in os.walk(args.output_directory):
            for filename in filenames:
                if filename.endswith('_processed.txt'):
                    txt_file = os.path.join(dirpath, filename)
                    process_interactions(args.sequence_file, txt_file, dirpath, args.lipids)
