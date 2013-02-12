## Copyright 2013 Sean McKenna
## 
##    Licensed under the Apache License, Version 2.0 (the "License");
##    you may not use this file except in compliance with the License.
##    You may obtain a copy of the License at
## 
##        http://www.apache.org/licenses/LICENSE-2.0
## 
##    Unless required by applicable law or agreed to in writing, software
##    distributed under the License is distributed on an "AS IS" BASIS,
##    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##    See the License for the specific language governing permissions and
##    limitations under the License.
##

# convert from a general data file to a set data file

# defines the CSV data filenames
inFile = "Penn-World-Table.csv"
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
#colNames = ['', 'A', 'B', 'C', 'D', 'E', 'F' , 'G']
#colNames = ['', '>40hrs/week', '>$14/hr', 'no kids', 'age <40yrs', 'not disabled', 'after 1983']
colNames = ['', 'OPEC', 'Communism', 'large population', 'large GDP/capita'] 
rows = []
i = 0

# process input file, row-by-row
for row in reader:
  
  # initialize row list
  newRow = []
  i += 1
  
  # skip column names in file
  if i > 1 and int(row[1]) == 1985:
    
    # add row number
    #newRow.append(str(i))
    newRow.append(row[2])
    
    # add if OPEC
    if row[3] == "yes":
      newRow.append(1)
    else:
      newRow.append(0)
    
    # add if Communism
    if row[4] == "yes":
      newRow.append(1)
    else:
      newRow.append(0)
    
    # add if large population
    if int(row[5]) > 30000:
      newRow.append(1)
    else:
      newRow.append(0)
    
    # add if large gdp/capita
    if int(row[6]) > 3400:
      newRow.append(1)
    else:
      newRow.append(0)

# labor supply data transformation    
#    # add if >40 hrs / week
#    if float(row[1]) > 7.640:
#      newRow.append(1)
#    else:
#      newRow.append(0)
#    
#    # add if >$14/hr
#    if float(row[2]) > 2.639:
#      newRow.append(1)
#    else:
#      newRow.append(0)
#    
#    # add if no kids
#    if int(row[3]) == 0:
#      newRow.append(1)
#    else:
#      newRow.append(0)
#    
#    # add if under 40
#    if int(row[4]) < 40:
#      newRow.append(1)
#    else:
#      newRow.append(0)
#    
#    # add if not disabled
#    if int(row[5]) == 0:
#      newRow.append(1)
#    else:
#      newRow.append(0)
#    
#    # add if after 1983
#    if int(row[7]) > 1983:
#      newRow.append(1)
#    else:
#      newRow.append(0)
    
# gene data transformation    
#    # add in raw data to row
#    newRow.append(row[1])
#    newRow.append(row[2])
#    newRow.append(row[3])
#    newRow.append(row[4])
#    newRow.append(row[5])
#    newRow.append(row[6])
#    newRow.append(row[7])
  
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
