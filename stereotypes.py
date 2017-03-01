import pandas
import codecs
import re
import json
import string
from collections import defaultdict
from nltk.corpus import stopwords
stopwords = stopwords.words('english')
modifiers= [('more','+'), ('not', '-'), ('less', '-')]
stopwords = [ i for i in stopwords if not i in [i[0] for i in modifiers]]+['to', 'a', 'and', 'for', 'in', 'with', 'this', 'of', 'the']

#let's establish gender stereotypes

files=[
'/Users/ps22344/Downloads/adapted_control_0206.csv', 
'/Users/ps22344/Downloads/Capitals_0212.csv', 
'/Users/ps22344/Downloads/Clippings_0208.csv', 
'/Users/ps22344/Downloads/Prosody_0211.csv', 
'/Users/ps22344/Downloads/Punctuation_0208.csv', 
'/Users/ps22344/Downloads/second_Emoticons_0228.csv', 
'/Users/ps22344/Downloads/Single letter_0218.csv'
]
for f in files:
	print f
	print pandas.read_csv(f, encoding="utf-8").shape
	
	#print len(codecs.open(f, "r", "utf-8").read().split("\n"))

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

kay= lambda x: re.sub("(more |less |likely to |w?o?men are |\.+ ?|also |always )", "", x.lower().lstrip(" "))

#men
men= sorted(df['men_are'].dropna(axis=0).tolist(), key=kay)
print "number of men posts", len(men)
with codecs.open("men.txt", "w", "utf-8") as menout:
	for i in men:
		menout.write(i+"\n")



#women
women= sorted(df['women_are'].dropna(axis=0).tolist(), key=kay)
print "number of women posts", len(women)
with codecs.open("women.txt", "w", "utf-8") as womenout:
	for i in women:
		womenout.write(i+"\n")


#comments
commie= sorted(df['further_comments'].dropna(axis=0).tolist(), key=kay)
print "number of comment posts", len(commie)
with codecs.open("commie.txt", "w", "utf-8") as commieout:
	for i in commie:
		commieout.write(i+"\n")


catdict={
("identical", "i") :[],
("synonym", "s") :[],
("joke", "j") :[],
("comment on survey", "c") :[],
("likelihood of response", "l") :[],
("attribute", "a"): [],
("behavior", "b"): [],
("picks up on previous questions", "p"): [],
("trash", "t"): [],
("feature comment", "f"): []
}
                    
def categorizer(input_list, file_name):
	"""
	put comments in categories, write to json
	"""
	for item in commie:
		print item
		cat= raw_input("put me in a category: ")
		for entry in catdict:
			if entry[0].startswith(cat):
				catdict[entry].append(item)
				print item, "added to ", entry
	with codecs.open(file_name, "w", "utf-8") as jsonout:
		json.dump({k[0]:v for k,v in catdict.items()}, jsonout)

jsons=[
'/Users/ps22344/Downloads/chapter4/jsonfiles/commentcats.json',
'/Users/ps22344/Downloads/chapter4/jsonfiles/mencats.json',
'/Users/ps22344/Downloads/chapter4/jsonfiles/womencats.json'
]

def extracter(json_file, entry_list):
	"""
	take only entries included in entry_list
	"""
	with codecs.open(json_file, "r", "utf-8") as inputjson:
		dicti= json.load(inputjson)
	print "keys included", dicti.keys()
	outputdicti= {k:v for k,v in dicti.items() if k in entry_list}
	return outputdicti
		
mendict= extracter(jsons[2], [u'picks up on previous questions', u'attribute', u'feature comment', u'behavior'])

menlist= [v for k,v in mendict.items()]
menlist = [val for sublist in menlist for val in sublist]
sortedmen= sorted(menlist, key=kay)
dicti=defaultdict(list)
for item in sortedmen:
	sent= [ i.strip(string.punctuation) for i in item.split(' ') if not i in stopwords and not i in string.punctuation]
	for m in [i for i in modifiers]:
		if m[0] in sent:
			indexi= [(i,x) for i,x in enumerate(sent)]
			indexes= [x[0] for x in indexi if x[1]==m[0]]
			#print "indi", indexes
			for ind in indexes:
				rangi= range(ind+1, ind+3)
				#print "ragni", rangi
				for ran in rangi:
					if all((ran < len(sent) , ind+ran > 0)):
						sent[ran]=sent[ran]+m[1]
			print sent
	for s in sent:
		dicti[s.strip(('-+')).lower()].append(s)
		
print "\n++++\n"		
with codecs.open('comments.txt', 'w', 'utf-8') as outi:
	for item in [(i, ",".join(dicti[i]), str(len(dicti[i]))) for i in sorted(dicti, key=lambda x: len(dicti[x]), reverse=True)]:
		if item[0] not in [i[0] for i in modifiers]:
			outi.write("\t".join(item)+"\n")
# 	

