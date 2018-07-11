import os

tsvFile = open("Eligibility.tsv","w",encoding="utf8")

rootPath = "/Users/sriramnarayanan/Downloads/AllPublicXml/"

subFolders = os.listdir(rootPath)
subFolders = subFolders[2:]

for subFolder in subFolders:
    files = os.listdir(rootPath+subFolder)
    for fname in files:
        
        file = open(rootPath+subFolder+"/"+fname, encoding = "utf-8")
        fileText = file.read()
        index = fileText.find("<criteria>")
        if index == -1: #look into alternate looping methods
            
            file.close()
            continue
            #go to next file
        
        index2 = fileText[index:].find("Exclusion Criteria")

        if index2 == -1:
            index2 =0

        #keep the nct number, inclusion/exclusion criteria, item, corresponding drug/intervention    
        index2 += index
            #go to next file
        index3 = fileText[index2:].find("</textblock>")
        if index3 == -1:
            file.close()
            continue
        
        index3 += index2
        if index2 == index:
            index2=index3
            #go to next file
        textBlock1 = fileText[int(index):int(index2)].replace("\n","").replace("\t","") #ask if this will lose information
        textBlock2 = fileText[int(index2):int(index3)].replace("\n","").replace("\t","")
        textBlock3 = str(fname.replace(".xml",""))
        textBlock1 = textBlock1.replace("<criteria>","").replace("<textblock>","")
        textBlock2 = textBlock2.replace("<criteria>","").replace("<textblock>","")
        
        tsvFile.write(textBlock1+"\t") #will this lose information
        tsvFile.write(textBlock2+"\t")
        tsvFile.write(textBlock3+"\n")
        #print(index, index2, index3)
        #print("TextBlock1:"+"\n"+textBlock1+"\n")
        #print("TextBlock2:"+"\n"+textBlock2+"\n"+"\n")
                      
        file.close()

#check if index = -1, if it does move to next file
#if else find index of next occurence of inclusion criteria
#then find index next occurrence of exclusion criteria
#then find index of next occurrence of <textblock>

#use python array indexing to 
#remove the "/ns" and "/ts" from those pieces of text



#NCT "tab" inclusion "tab" exclusion"




