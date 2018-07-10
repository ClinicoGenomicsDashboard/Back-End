#start with first demarcator
#have a flag that indicates if you've hit demarcator, if flag = 0, append cell to list
#remove words followed by colon
#when you hit colon, start deleting from end of buffer until reaching space
# search for either space space space heifen space or space space space number .
# keep scanning cell until you hit a demarcator, then add everything into a bullet point

import csv

bulletFile = open("InclusionExclusionBulletPoint.tsv","w",encoding="latin-1")

with open("EligibilityCriteriaDocument.txt","r",encoding="latin-1") as tsvFile:
    tsvContents = csv.reader(tsvFile, delimiter='\t')
    goodCount = 0
    count = 0
    for row in tsvContents:
        count +=1
        #if count!= 60567:
            #continue
        inclusion = row[10]
        exclusion = row[11]
        nctNumber = row[1]
        intervention = row[4]
        condition = row[3]
        gender = row[5]
        age = row[6]
        nctNumber = str(nctNumber)
        intervention = str(intervention)
        condition = str(condition)
        gender = str(gender)
        age = str(age)            
        inclusionList = []
        exclusionList = []
        flag = 0
        buffer = ""
        inclusion = str(inclusion)
        exclusion = str(exclusion)
        for i in range(len(inclusion)):

            if inclusion[i] == ":":
                k= i-1
                while inclusion[k] != " ":
                    k -= 1
                buffer = buffer[:k]
                #print(inclusion)
                continue
                
            if i+4 < len(inclusion) and inclusion[i] == " " and inclusion[i+1] == " " and inclusion[i+2] == " " and inclusion[i+3] == "-" and inclusion[i+4] == " ":
                if flag == 1:
                    inclusionList.append(buffer.strip(" "))
                    bulletFile.write(nctNumber + "\t" + condition + "\t" + "indication" + "\t" + buffer.strip(" ") + "\t" + intervention + "\n")  
                buffer = ""
                i = i+4

                flag = 1
                continue
            
            if i+4 < len(inclusion) and inclusion[i] == " " and inclusion[i+1] == " " and inclusion[i+2] == " " and inclusion[i+3].isdigit():
                k = i+4
                
                while inclusion[k].isdigit():
                    k += 1

                if inclusion[k] == ".":
                    if flag == 1:
                        inclusionList.append(buffer.strip(" "))
                        bulletFile.write(nctNumber + "\t" + condition + "\t" + "indication" + "\t" + buffer.strip(" ") + "\t" + intervention + "\n")
                    buffer = ""
                    i = k+1
                    flag = 1
                    continue


            buffer += inclusion[i]

        if flag == 0:
            inclusionList.append(inclusion)
            bulletFile.write(nctNumber + "\t" + condition + "\t" + "indication" + "\t" + inclusion + "\t" + intervention + "\n")
            
        else:
            inclusionList.append(buffer.strip(" "))
            bulletFile.write(nctNumber + "\t" + condition + "\t" + "indication" + "\t" + buffer.strip(" ") + "\t" + intervention + "\n")
            goodCount += 1

        bulletFile.write(nctNumber + "\t" + condition + "\t" + "indication" + "\t" + gender + "\t" + intervention + "\n")
        bulletFile.write(nctNumber + "\t" + condition + "\t" + "indication" + "\t" + age + "\t" + intervention + "\n") 



        #write id number \t indication \t item \n to the file wherever you do inclusionlist.append


        flag = 0
        buffer = ""
        for i in range(len(exclusion)):
            
            if exclusion[i] == ":":
                k= i-1
                while exclusion[k] != " ":
                    k -= 1
                buffer = buffer[:k]
                #print(exclusion)
                continue
                
            if i+4 < len(exclusion) and exclusion[i] == " " and exclusion[i+1] == " " and exclusion[i+2] == " " and exclusion[i+3] == "-" and exclusion[i+4] == " ":
                if flag == 1:
                    exclusionList.append(buffer.strip(" "))
                    bulletFile.write(nctNumber + "\t" + condition + "\t" + "counterindication" + "\t" + buffer.strip(" ") + "\t" + intervention + "\n")

                buffer = ""
                i = i+4

                flag = 1
                continue
            
            if i+4 < len(exclusion) and exclusion[i] == " " and exclusion[i+1] == " " and exclusion[i+2] == " " and exclusion[i+3].isdigit():
                k = i+4
                
                while exclusion[k].isdigit():
                    k += 1

                if exclusion[k] == ".":
                    if flag == 1:
                        exclusionList.append(buffer.strip(" "))
                        bulletFile.write(nctNumber + "\t" + condition + "\t" + "counterindication" + "\t" + buffer.strip(" ") + "\t" + intervention + "\n")

                    buffer = ""
                    i = k+1
                    flag = 1
                    continue


            buffer += exclusion[i]

        if flag == 0:
            exclusionList.append(exclusion)
            bulletFile.write(nctNumber + "\t" + condition + "\t" + "counterindication" + "\t" + exclusion + "\t" + intervention + "\n")

            
        else:
            exclusionList.append(buffer.strip(" "))
            bulletFile.write(nctNumber + "\t" + condition + "\t" + "counterindication" + "\t" + buffer.strip(" ") + "\t" + intervention + "\n")
            goodCount += 1
            #copy paste, replace "inclusion" with "exclusion"

        #write id number \t indication \t item \n to the file wherever you do exclusionlist.append




        #take row[0] for id number 

        #print(inclusionList)
        #write to new file
        # id \t inclusion/exclusion \t item \n    


bulletFile.close()


