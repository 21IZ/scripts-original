import os
import csv
import re
import argparse
from collections import defaultdict

def is_file_empty(file_path):
    """Check if a file is empty."""
    return os.path.exists(file_path) and os.stat(file_path).st_size == 0

def extract_numeric_part(text):
    """Helper function to extract the numeric part of a text."""
    match = re.search(r'\d+', text)
    return int(match.group()) if match else 0

def transform_fp(input_file, output_file):
    """Transforms the input CSV file replacing True with 1 and False with 0."""
    if is_file_empty(input_file):
        print(f"Error: The input file '{input_file}' is empty.")
        return

    try:
        with open(input_file, "r") as infile, open(output_file, "w") as outfile:
            for line in infile:
                outfile.write(line.replace("True", "1").replace("False", "0"))
    except Exception as e:
        print(f"Error transforming file '{input_file}': {e}")

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

def organize_results_data(base_directory):
    """Organizes data from TXT files into the 'results' folder and subdirectories."""
    for dirpath, _, filenames in os.walk(base_directory):
        for filename in filenames:
            if filename.endswith('_processed.txt'):
                txt_file = os.path.join(dirpath, filename)
                csv_name = filename.replace('processed', 'organized').replace('.txt', '.csv')
                csv_file = os.path.join(dirpath, csv_name)
                organize_txt_data(txt_file, csv_file, filename.split('_')[0])
                print(f"Organized CSV file saved as {csv_name} in {dirpath}")

def organize_txt_data(txt_file, csv_file, interaction_name):
    """Organizes data from a TXT file and saves it to a CSV file."""
    try:
        with open(txt_file, 'r') as file:
            # Read and process lines, removing empty ones and separating elements by tabs
            data = [line.strip().split('\t') for line in file if line.strip()]

        # Sort data by the first column (ARG) in ascending order
        data.sort(key=lambda x: (extract_numeric_part(x[0]), x[1]))

        # Transpose the data and write to CSV file
        transposed_data = list(zip(*data))

        # Insert the interaction name in the third row
        if len(transposed_data) >= 3:
            transposed_data[2] = [interaction_name] * len(transposed_data[2])

        with open(csv_file, 'w', newline='') as csvfile:
            writer = csv.writer(csvfile)
            writer.writerows(transposed_data)
    except Exception as e:
        print(f"Error organizing TXT data from file '{txt_file}': {e}")

def process_consensus(csv_input, csv_output):
    """Processes the input CSV to create a consensus output."""
    try:
        with open(csv_input, newline='') as csvfile:
            rows = list(csv.reader(csvfile))

        column_dict = defaultdict(list)

        for col_index, col_key in enumerate(zip(rows[0], rows[1])):
            column_dict[col_key].append(col_index)

        new_columns = []
        for (key1, key2), col_indices in column_dict.items():
            new_column = [key1, key2, rows[2][col_indices[0]]]
            new_column.extend(
                '1' if any(rows[row_index][col_index] == '1' for col_index in col_indices) else '0'
                for row_index in range(3, len(rows))
            )
            new_columns.append(new_column)

        with open(csv_output, 'w', newline='') as csvfile:
            writer = csv.writer(csvfile)
            writer.writerows(zip(*new_columns))
    except Exception as e:
        print(f"Error processing consensus for file '{csv_input}': {e}")

def consensus_organized(base_directory):
    """Executes the consensus process on the organized CSV files."""
    for dirpath, _, filenames in os.walk(base_directory):
        for filename in filenames:
            if filename.endswith('_organized.csv'):
                input_file = os.path.join(dirpath, filename)
                output_file = os.path.join(dirpath, filename.replace('_organized', '_consensus'))
                process_consensus(input_file, output_file)
                print(f"Consensus file generated as {output_file}")

def main():
    parser = argparse.ArgumentParser(description="Process fingerprint percentage data.")
    parser.add_argument("-if", "--input_file", required=True, help="Name of the input CSV file.")
    parser.add_argument("-o", "--output_directory", required=True, help="Name of the base directory for results.")
    args = parser.parse_args()

    original_input_file = args.input_file
    transformed_input_file = "fingerprint_binary.csv"
    base_directory = args.output_directory

    if is_file_empty(original_input_file):
        print(f"Error: The input file '{original_input_file}' is empty.")
        return

    # Execute transformation
    transform_fp(original_input_file, transformed_input_file)

    # Execute interaction separation
    separate_interactions(transformed_input_file, base_directory)

    # Execute TXT data organization
    organize_results_data(base_directory)

    # Execute consensus on organized CSV files
    consensus_organized(base_directory)

if __name__ == "__main__":
    main()
