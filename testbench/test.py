import argparse
import subprocess
import os

def main():
    parser = argparse.ArgumentParser(description='Adv Arch OoO Testbench')
    parser.add_argument('cpu', type=str, help='Path to your CPU implementation')
    parser.add_argument('testcase', type=str, help='Path to the testcase elf')
    parser.add_argument('expected', nargs="?", type=str, help='Path to the expected output of the testcase')

    args = parser.parse_args()

    # Execute the command
    command = ['llvm-objcopy', '-O', 'binary', '-j', '.text', args.testcase, '-']
    result = subprocess.run(command, capture_output=True)

    # Check if the command executed successfully
    if result.returncode == 0:
        # Get the binary output
        binary_output = result.stdout

        hex_string = binary_output.hex()

        # Split the hex string into bytes
        bytes_ = [hex_string[i:i+2] for i in range(0, len(hex_string), 2)]

        # Split the bytes into chunks of 4
        chunks = ["".join(bytes_[i:i+4][::-1]) for i in range(0, len(bytes_), 4)]

        # Join the chunks with a space separator
        hex_string = '\n'.join(chunks)

        script_dir = os.path.dirname(os.path.abspath(__file__))
        tmp_dir = os.path.join(script_dir, 'tmp')
        hex_file_path = os.path.join(tmp_dir, 'mem.hex')

        with open(hex_file_path, 'w') as file:
            file.write("@0\n")
            file.write(hex_string)

        # Run iverilog
        testbench_path = os.path.join(script_dir, 'testbench.sv')
        iverilog_out_path = os.path.join(tmp_dir, 'exe')
        command = ['iverilog', '-o', iverilog_out_path, '-g2012', testbench_path, args.cpu]
        print(" ".join(command))
        result = subprocess.run(command)
        if result.returncode == 0:
            # Run vvp
            command = ['vvp', iverilog_out_path]
            result = subprocess.run(command, cwd=tmp_dir, capture_output=True)
            if result.returncode == 0:
                print("Test run successfully")
                # Remove lines from output we don't want
                output = result.stdout.decode('utf-8').split('\n')
                output = [line for line in output if not (line.startswith('VCD info') or "$finish" in line)]
                # Write the actual output to a file
                with open(os.path.join(tmp_dir, 'output.txt'), 'w') as file:
                    file.write('\n'.join(output))
                # If an expected output file is provided, run diff
                if args.expected:
                    command = ['diff', os.path.join(tmp_dir, 'output.txt'), args.expected]
                    print("Diff output:")
                    result = subprocess.run(command)
                    if result.returncode == 0:
                        print("Test passed")
                    else:
                        print("Test failed")
            else:
                print("Verilog execution failed")
    else:
        # Print an error message
        print(f"Command execution failed with error code {result.returncode}")



if __name__ == '__main__':
    main()