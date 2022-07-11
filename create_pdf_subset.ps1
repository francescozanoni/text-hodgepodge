# Example from pdftk's CLI help:
#
#   Remove page 13 from in1.pdf to create out1.pdf
#     pdftk in.pdf cat 1-12 14-end output out1.pdf
#   or:
#     pdftk A=in1.pdf cat A1-12 A14-end output out1.pdf

pdftk my_input_file.pdf cat 9-25 27 29-45 47 49-54 output my_output_file.pdf
