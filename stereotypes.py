import pandas
import codecs



#let's establish gender stereotypes

files=[
'/Users/ps22344/Downloads/adapted_control_0206.csv', 
'/Users/ps22344/Downloads/Capitals_0212.csv', 
'/Users/ps22344/Downloads/Clippings_0208.csv', 
'/Users/ps22344/Downloads/Prosody_0211.csv', 
'/Users/ps22344/Downloads/Punctuation_0208.csv', 
'/Users/ps22344/Downloads/second_Emoticons_0211.csv', 
'/Users/ps22344/Downloads/Single letter_0218.csv'
]


cols=["start_date"                                            
 , "end_date"                                              
 , "response_type"                                         
 , "progress"                                              
 , "duration_in_seconds"                                 
 , "finished"                                              
 , "recorded_date"                                         
 , "recipient_Last_Name"                                   
 , "recipient_first_Name"                                  
, "recipient_email"                                       
, "external_data_reference"                               
, "location_Latitude"                                     
, "location_Longitude"                                    
, "distribution_Channel"                                  
, "author_gender"                                     
, "author_orient"                                   
, "author_friendly"                                   
, "author_audience"                       
, "author_sensitive"                                  
, "author_ethnicity"                           
, "author_assertive"                                
, "author_attractive"                                
, "author_education"                                
, "men_are"                                           
, "women_are"                                         
, "would_you_reply"                           
, "further_comments"       
, "participant_gender"                            
, "participant_gender_other"               
, "participant_ethnicity"               
, "participant_ethnicity_other"  
, "participant_age"                                               
, "participant_orientation"             
, "participant_orientation_other"
, "participant_grew_up"                
, "participant_residence"]                 

badcols= ["IPAddress", "ResponseId", "mTurkCode"]


#first two lines are trash
df = pandas.concat((pandas.read_csv(f, 
skiprows=2, 
#remove badcols
usecols=[i for i in range(0,39) if not i in [3,8,38]],
encoding='utf-8',
na_values='""') for f in files))
#df.columns= ['a','b','c']
print 'shape of the data frame', df.shape
df.columns= cols
df = df[df['response_type'] != 'Survey Preview']
print 'shape of the data frame', df.shape
print df.columns

#men
men= sorted(df['men_are'].dropna(axis=0))
print "number of men posts", len(men)
with codecs.open("men.txt", "w", "utf-8") as menout:
	for i in men:
		menout.write(i+"\n")



#women
women= sorted(df['women_are'].dropna(axis=0))
print "number of women posts", len(women)
with codecs.open("women.txt", "w", "utf-8") as womenout:
	for i in women:
		womenout.write(i+"\n")


#comments
commie= sorted(df['further_comments'].dropna(axis=0))
print "number of comment posts", len(commie)
with codecs.open("commie.txt", "w", "utf-8") as commieout:
	for i in commie:
		commieout.write(i+"\n")




#print 'shape of the data frame', men.shape

# , "men_are"                                           
# , "women_are"                                         
# , "would_you_reply"                           
# , "further_comments"   



df.to_csv("outi.csv", na_rep= "XXXXX")



#df = df.drop(badcols, axis=1)
#print df.iloc[2,:]