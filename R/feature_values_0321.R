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


#are features emoticon, prosody, perceived as attractive by target population?

for (st in levels(fullspread[['stimulus']])){
	temp= fullspread[fullspread[['stimulus']] == st,]
	cat ("\nworking on", st, "\n")
	#print(colnames(temp))
	gendered= split(temp, temp[['author_gender']])
	print (colnames(gendered$female))
	female= gendered$female[,perceptionfeatures]
	womenmeans= lapply(female, function(x) names(female)[sapply(female, function(i) identical(i, x))])
	womenmeans= lapply(female, function(x) mean(as.numeric(x), na.rm= TRUE))
	male= gendered$male[,perceptionfeatures]
	menmeans= lapply(male, function(x) mean(as.numeric(x), na.rm= TRUE))
	total= rbind(womenmeans, menmeans)
	print total
	total = Map(c, womenmeans, menmeans)
	print total
	}

#are features rated the same on education, etc, no matter what the gender score?

