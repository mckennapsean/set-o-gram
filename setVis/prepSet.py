# by Sean McKenna
# convert set data file

# defines the CSV data filenames
inFile = "genes.csv"
outFile = "out.csv"

# necessary imports
import csv
import time

# start timer
start = time.time()

# get the CSV data file as input
input = open(inFile, "rU")
reader = csv.reader(input)

# set up CSV data file as output
output = open(outFile, "wb")
writer = csv.writer(output)

# initialize lists
#colNames = ['', 'survived', 'adult', 'male', 'first-class']
colNames = ['', 'A', 'B', 'C', 'D', 'E', 'F' , 'G']
rows = []
i = 0

# process input file, row-by-row
for row in reader:
  
  # initialize row list
  newRow = []
  i += 1
  
  # skip column names in file
  if i > 1:
    
    # add row number
    newRow.append(str(i))
    
    # add in raw data to row
    newRow.append(row[1])
    newRow.append(row[2])
    newRow.append(row[3])
    newRow.append(row[4])
    newRow.append(row[5])
    newRow.append(row[6])
    newRow.append(row[7])
  
# titanic data transformation  
#  # add if survived
#  if row[3] == "Survived":
#    newRow.append(1)
#  else:
#    newRow.append(0)
#  
#  # add if adult
#  if row[1] == "Adult":
#    newRow.append(1)
#  else:
#    newRow.append(0)
#  
#  # add if male
#  if row[2] == "Male":
#    newRow.append(1)
#  else:
#    newRow.append(0)
#  
#  # add if first-class
#  if row[0] == "First Class":
#    newRow.append(1)
#  elif row[0] == "Second Class":
#    newRow.append(2)
#  elif row[0] == "Third Class":
#    newRow.append(3)
#  else:
#    newRow.append(4)
    
    # add row to all rows data
    rows.append(newRow)
  
# write the first row names
writer.writerow(colNames)

# write all the columns row-by-row
for row in rows:
  row[0] += "\""
  writer.writerow(row)

# close all files
input.close()
output.close()

# stop timer
end = time.time()

# process the time elapsed
elapsed = end - start
min = round(elapsed / 60, 3)

# display time taken
print "Data conversion operation complete after", min, "minutes."
