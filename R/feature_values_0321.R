###
#Establish feature value for Chptr4
###

for (package in c("devtools", "roxygen2", "pwr", "effsize", "likert")) {
    if (!require(package, character.only=T, quietly=T)) {
        install.packages(package, repos='http://cran.us.r-project.org')
        library(package, character.only=T)
    }
}

setwd('~/Downloads/chapter3')
install('surveytools')
library('surveytools')

setwd('~/Downloads/chapter4/rplots')


files=c(
'/Users/ps22344/Downloads/adapted_control_0206.csv', 
'/Users/ps22344/Downloads/Capitals_0212.csv', 
'/Users/ps22344/Downloads/Clippings_0208.csv', 
'/Users/ps22344/Downloads/Prosody_0211.csv', 
'/Users/ps22344/Downloads/Punctuation_0208.csv', 
'/Users/ps22344/Downloads/second_Emoticons_0228.csv', 
'/Users/ps22344/Downloads/Single\ letter_0218.csv'
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

menonly= fullspread[fullspread[['author_gender']] == 'male'&fullspread[['author_orient']] == 'heterosexual'&fullspread[['author_audience']] == 'woman',]
womenonly= fullspread[fullspread[['author_gender']] == 'female'&fullspread[['author_orient']] == 'heterosexual'&fullspread[['author_audience']] == 'man',]
gaymenonly= fullspread[fullspread[['author_gender']] == 'male'&fullspread[['author_orient']] == 'homosexual'&fullspread[['author_audience']] == 'man',]
gaywomenonly= fullspread[fullspread[['author_gender']] == 'female'&fullspread[['author_orient']] == 'homosexual'&fullspread[['author_audience']] == 'woman',]

fullspread=rbind(menonly, womenonly)


#are features emoticon, prosody, perceived as attractive by target population?
sink("feature_values_0321.txt")
for (st in levels(fullspread[['stimulus']])){
	temp= fullspread[fullspread[['stimulus']] == st,]
	#temp= temp[,perceptionfeatures]
	cat ("\nworking on", st, "\n")
	gendered= split(temp, temp[['author_gender']])
	female= gendered$female[,perceptionfeatures]
	male= gendered$male[,perceptionfeatures]
	womenmeans= lapply(female, function(x) mean(as.numeric(x), na.rm= TRUE))
	menmeans= lapply(male, function(x) mean(as.numeric(x), na.rm= TRUE))
	total= rbind(womenmeans, menmeans)
	#lapply(temp[,perceptionfeatures], function(x) print(names(temp)[sapply(temp, function(i) identical(i,x))]))
	lapply(temp[,perceptionfeatures], function(x) {print(names(temp)[sapply(temp, function(i) identical(i,x))]);tryCatch(print(t.test (as.numeric(x) ~ temp[['author_gender']])), error=function(e) print(e))})
}
sink()
#are features rated the same on education, etc, no matter what the gender score?

