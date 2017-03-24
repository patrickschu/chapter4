###
#Establish feature value for Chptr4
###

for (package in c("devtools", "roxygen2", "pwr", "effsize", "likert")) {
    if (!require(package, character.only=T, quietly=T)) {
        install.packages(package, repos='http://cran.us.r-project.org')
        library(package, character.only=T)
    }
}

setwd('E:\\cygwin\\home\\ps22344\\Downloads\\chapter3')
install('surveytools')
library('surveytools')

setwd('rplots')


files=c(
'adapted_control_0206.csv', 
'Capitals_0212.csv', 
'Clippings_0208.csv', 
'Prosody_0211.csv', 
'Punctuation_0208.csv', 
'second_Emoticons_0228.csv', 
'Single\ letter_0218.csv'
)



perceptionfeatures=c(            
"author_gender"                                     
, "author_orient" 
, "author_audience" 
,"cat"  
, "author_assertive"  
, "author_education"                                
, "author_friendly"  
, "author_sensitive"                                  
, "author_ethnicity"                           
, "author_attractive"                                
, "would_you_reply"  
)

perceptionfeatures_text=c(
"men_are"                                           
, "women_are"   
, "further_comments"
)

participantfeatures=c(
"participant_gender"                            
, "participant_gender_other"               
, "participant_ethnicity"               
, "participant_ethnicity_other"  
, "participant_age"                                               
, "participant_orientation"             
, "participant_orientation_other"
, "participant_grew_up"                
, "participant_residence") 


participantfeaturesnumeric=c(
"participant_gender"                            
      
, "participant_ethnicity"               
, "participant_age"                                               
, "participant_orientation"             
) 

fullspread=spreadsheetbuilder(files)

#get only heteromen rating it female, heterowomen rating it male
males=fullspread[(fullspread[['participant_orientation']] == "heterosexual")&(fullspread[['participant_gender']] == "male")&(fullspread[['author_gender']]=="female"),]
cat ("males mean attractive", mean(as.numeric(males$author_attractive), na.rm=TRUE))

females=fullspread[(fullspread[['participant_orientation']] == "heterosexual")&(fullspread[['participant_gender']] == "female")&(fullspread[['author_gender']]=="male"),]
cat ("females mean attractive", mean(as.numeric(females$author_attractive), na.rm=TRUE))


cat ("we got so many lines:", nrow(females)+nrow(males))
fulli= rbind(males, females)
print (nrow(fulli))
mean(as.numeric(fulli$author_attractive), na.rm=TRUE)

###how does their attractiveness rating change btw features?
##MEN
ugly=males[(males[['stimulus']] != "Emoticons")&(males[['stimulus']] != "Prosody"),]
beauty= males[(males[['stimulus']] == "Prosody")|(males[['stimulus']] == "Emoticons"),]
cat ("\nmean for male participants, ugly features", mean(as.numeric(ugly$author_attractive), na.rm=TRUE))
cat ("\nmean for male participants,  beauty features", mean(as.numeric(beauty$author_attractive), na.rm=TRUE))
print(t.test(as.numeric(ugly$author_attractive),as.numeric(beauty$author_attractive)))
cat ("\nwyr mean for male participants, ugly features", mean(as.numeric(ugly$would_you_reply), na.rm=TRUE))
cat ("\nwyr mean for male participants,  beauty features", mean(as.numeric(beauty$would_you_reply), na.rm=TRUE))



#mean for emoticon + prosody versus rest


#mean for stimulus emoticon compared to rest

#mean for stimulus prosody comp to rest
