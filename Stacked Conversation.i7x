Version 2 of Stacked Conversation by Daniel Gaskell begins here.

"A comprehensive conversation system that implements numerous types of interactions and provides tools for creating conversations that flow naturally and adapt to context."

[Changelog

RELEASE 2
- Spelling errors, minor documentation/example tweaks
- Added verbless parsing
- Added requirements system

RELEASE 1
- Initial release]

Book 1 - Globals

Chapter 1.1 - Options

To greet is a verb. To react is a verb. To accomplish is a verb. To think is a verb. To discuss is a verb. To change is a verb. To speak is a verb. To respond is a verb.

Use manual quip-matching only translates as (- Constant NO_CONV_DISAM; -). 

Use verbless parsing translates as (- Constant VERBLESS_CONV; -). 

Chapter 1.2 - Variables

conversing is a truth state that varies. conversing is false.
the interlocutor is an object that varies. the interlocutor is nothing.
the last quip is an object that varies. the last quip is nothing.

conversed-this-turn is a truth state that varies. conversed-this-turn is false.
on-first-quip is a truth state that varies. on-first-quip is false.
Every turn (this is the reset conversation variables rule):
	now conversed-this-turn is false;
	now on-first-quip is true.

Chapter 1.3 - Subjects (for use without Epistemology by Eric Eve)

A subject is a kind of thing.

A thing can be known or unknown. A thing is usually known.
	
Chapter 1.4 - Routines

Section 1.4.1 - Or-listing

To say an or-list of (the active list - a list of objects):
	let tmp-ticker be a number;
	let tmp-last be the number of entries in the active list minus 1;
	let tmp-next-to-last be the number of entries in the active list minus 2;
	repeat with printobject running through the active list:
		say "[printed name of the printobject][run paragraph on]";
		if the number of entries in the active list is greater than 2:
			if tmp-ticker is less than tmp-next-to-last or (the serial comma option is active and tmp-ticker is less than tmp-last), say ",[run paragraph on]";
			if tmp-ticker is less than tmp-next-to-last, say " [run paragraph on]";
		if the number of entries in the active list is greater than 1 and tmp-ticker is tmp-next-to-last, say " or [run paragraph on]";
		increment tmp-ticker;
	say "".
	
Section 1.4.2 - Keyword matching

To decide if (the haystack text - an text) matches one of (the needle list - a list of text):
	let tmpneedles be a list of text;
	now tmpneedles is the needle list; [no idea why it's needed, but using the original always matches]
	repeat with tmpneedle running through tmpneedles:
		if the haystack text matches the text tmpneedle, yes;
	no.

To decide if (the haystack text - an text) matches all of (the needle list - a list of text):
	let tmpneedles be a list of text;
	now tmpneedles is the needle list; [no idea why it's needed, but using the original always matches]
	repeat with tmpneedle running through tmpneedles:
		unless the haystack text matches the text tmpneedle, no;
	yes.
	
To decide if (the haystack text - an text) matches one of the keywords (the needle list - a list of texts):
	let tmpneedles be a list of text;
	now tmpneedles is the needle list; [no idea why it's needed, but using the original never matches]
	repeat with tmpticker running from 1 to the number of words in the haystack text:
		if word number tmpticker in the haystack text is listed in tmpneedles, yes;
	no.

To decide if (the haystack text - an text) matches all of the keywords (the needle list - a list of text):
	let tmpneedles be a list of text;
	now tmpneedles is the needle list; [no idea why it's needed, but using the original never matches]
	let tmp-flag-found be a truth state;
	repeat with tmpworditem running through tmpneedles:
		now tmp-flag-found is false;
		repeat with tmpticker running from 1 to the number of words in the haystack text:
			if word number tmpticker in the haystack text exactly matches the text tmpworditem, now tmp-flag-found is true;
		if tmp-flag-found is false, no;
	yes.
	
To decide what number is the number of words in (the haystack text - an text) that match the keywords (the needle list - a list of text):
	let tmptally be a number;
	let tmpneedles be a list of text;
	now tmpneedles is the needle list; [no idea why it's needed, but using the original never matches]
	repeat with tmpticker running from 1 to the number of words in the haystack text:
		if word number tmpticker in the haystack text is listed in tmpneedles, increment tmptally;
	decide on tmptally.
	
Section 1.4.3 - Line input

[Adapted from samples in Roger Firth's Inform 6 FAQ, with suggestions from Andrew Plotkin - thanks!]

Include (-
		Constant	alt_input_buffer_SIZE 128;
		Array		alt_input_buffer buffer alt_input_buffer_SIZE;
		
		#Ifdef TARGET_ZCODE;

			[ KeyLine buf max;
				buf->0 = max;
				buf->1 = 0;
				read buf 0;
				buf->0 = 0;
				return buf-->0;
			];

		#Ifnot; ! TARGET_GLULX

			[ KeyLine buf max;
				glk($00D0, gg_mainwin, buf+WORDSIZE, max, 0); ! request_line_event
				while (true) {
					glk($00C0, gg_event); ! select
					if (gg_event-->0 == 3 && gg_event-->1 == gg_mainwin) break;
				}
				buf-->0 = gg_event-->2;
				return buf-->0;
			];

		#Endif; ! TARGET_
		
		  [ PrintString buf
			  i;
			  for (i=0 : i<buf-->0 : i++)
				  print (char) buf->(i+WORDSIZE);
		  ];
	-)

To input a string:
	(-
		do
			print ">";
		until (KeyLine(alt_input_buffer, alt_input_buffer_SIZE));
	-)
	
To say alt_input_buffer: (- PrintString(alt_input_buffer); -)
	
Chapter 1.4.4 - Verbless conversation

sc-old-command is a text that varies.
sc-reparsing is initially false.

Rule for printing a parser error when the verbless parsing option is active and conversing is true and the latest parser error is the not a verb I recognise error:
	now sc-old-command is the player's command;
	now sc-reparsing is true.
	
Rule for reading a command when sc-reparsing is true:
	now sc-reparsing is false;
	change the text of the player's command to "ask about [the player's command]";
	say run paragraph on.

Book 2 - Quips

A quip is a kind of thing.
A quip can be said or unsaid. A quip is usually unsaid.
A quip can be automatic, obligatory, optional, or unimportant. A quip is usually unimportant.
A quip has an object called the topic category.
A quip can be available or not available. A quip is usually available.
A quip can be randomly-deliverable or not randomly-deliverable. A quip is usually not randomly-deliverable.

A quip has an object called speaker.
A quip has a list of objects called ask objects.
A quip has a list of texts called ask words.

Book 3 - NPCs

A person has an object called the conversation topic.
A person has an object called the group conversation stand-in.

A person has a number called quip talkativeness. The quip talkativeness of a person is usually 2.
A person has a number called quip assertiveness. The quip assertiveness of a person is usually 5.
A person has a number called topic talkativeness. The topic talkativeness of a person is usually 3.

A person has a list of objects called the active quip stack.
A person has a list of objects called the delayed quip stack.

A person can be conversationally mobile. A person is usually not conversationally mobile.

Book 4 - Quip delivery

Chapter 4.1 - Delivering quips

Section 4.1.1 - Basic delivery

Listing is an object based rulebook.

To deliver (the active quip - a quip):
	if the active quip is not deliverable or the active quip is not topic-legal:
		deliver the default response quip of the interlocutor;
	otherwise:
		now conversed-this-turn is true;
		if the interlocutor is not nothing:
			if the topic category of the active quip is not nothing:
				if the conversation topic of the interlocutor is not the topic category of the active quip:
					if the conversation topic of the interlocutor is not nothing:
						try transitioning from the conversation topic of the interlocutor to the topic category of the active quip;
					otherwise:
						try transitioning to the topic category of the active quip;
					now the conversation topic of the interlocutor is the topic category of the active quip;
					let removeitems be a list of objects;
					repeat with checkitem running through the active quip stack of the interlocutor:
						if the topic category of checkitem is not the topic category of the active quip and the topic category of checkitem is not nothing and checkitem is not automatic and checkitem is not obligatory:
							add checkitem to removeitems;
					remove removeitems from the active quip stack of the interlocutor;
		if a paragraph break is pending, say "[conditional paragraph break]";
		say the initial appearance of the active quip;
		if the initial appearance of the active quip is not "", say "[line break]"; [the odd phrasing of these last two lines is necessary because the initial appearance will sometimes match "" until it's been said, even if it shouldn't; this is a roundabout way of doing nothing if blank, and printing the initial appearance with a line break if not.]
		follow the listing rules for the active quip;
		now the active quip is said;
		now the last quip is the active quip;
		now on-first-quip is false;
		if the interlocutor is not nothing:
			if the active quip is listed in the active quip stack of the interlocutor:
				remove the active quip from the active quip stack of the interlocutor;
			if the active quip is listed in the delayed quip stack of the interlocutor:
				remove the active quip from the delayed quip stack of the interlocutor;
			if a random chance of 1 in the quip assertiveness of the interlocutor succeeds:
				if the number of entries in the active quip stack of the interlocutor is 0:
					if a random chance of 1 in the topic talkativeness of the interlocutor succeeds:
						change the conversation topic;
				otherwise:
					deliver entry 1 in the active quip stack of the interlocutor.
					
To conditionally deliver (the active quip - a quip):
	if the active quip is unsaid, deliver the active quip.

Every turn when conversing is true (this is the deliver automatic quips rule):
	if the interlocutor is not nothing:
		let topautomatic be an object;
		repeat with checkitem running through the active quip stack of the interlocutor:
			if checkitem is automatic:
				now topautomatic is checkitem;
		if topautomatic is not nothing:	[active stack has automatic quip]
			deliver topautomatic.
			
Every turn when conversing is true (this is the automatically change the subject rule):
	if the interlocutor is not nothing:
		if conversed-this-turn is false:
			if the number of entries in the active quip stack of the interlocutor is 0:
				if a random chance of 1 in the topic talkativeness of the interlocutor succeeds:
					change the conversation topic;
			otherwise:
				if a random chance of 1 in the quip talkativeness of the interlocutor succeeds:
					deliver entry 1 of the active quip stack of the interlocutor.
	
To change the conversation topic:
	if the interlocutor is not nothing:
		if the number of entries in the delayed quip stack of the interlocutor is not 0:
			deliver entry 1 of the delayed quip stack of the interlocutor;
		otherwise:
			let quiplist be the list of deliverable relevant topic-legal unsaid randomly-deliverable quips;
			if the number of entries in quiplist is not 0 and nothing is not listed in quiplist, deliver entry (a random number from 1 to the number of entries in quiplist) in quiplist.

Section 4.1.2 - Ambiguous delivery

To decide which quip is the first available quip in (quiplist - a list of quips):
	repeat with tested quip running through the quiplist:
		if tested quip is deliverable and the tested quip is unsaid, decide on tested quip;
	repeat with tested quip running through the quiplist:
		if tested quip is deliverable, decide on tested quip;
	decide on the default response quip of the interlocutor.
	
Disambiguation-quips is a list of objects that varies.

To disambiguate the quips (quiplist - a list of quips) (this is the disambiguation procedure rule):
	truncate disambiguation-quips to 0 entries;
	repeat with tested quip running through the quiplist: [first try compiling only unsaid]
		if tested quip is deliverable and the tested quip is unsaid:
			add tested quip to disambiguation-quips;
	if the number of entries in disambiguation-quips is 0:
		truncate disambiguation-quips to 0 entries;
		repeat with tested quip running through the quiplist: [if none, try compiling said too]
			if tested quip is deliverable:
				add tested quip to disambiguation-quips;
	if the number of entries in disambiguation-quips is 1:
		deliver entry 1 in disambiguation-quips;
	otherwise if the number of entries in disambiguation-quips is 0:
		deliver the default response quip of the interlocutor;
	otherwise:
		follow the disambiguation question rule; [because phrases can't uses lettered responses]
		input a string;
		let tmp-found be a truth state;
		let tmp_input_buffer be the substituted form of "[alt_input_buffer]";
		[check for exact matches]
		repeat with testquip running through disambiguation-quips:
			if the printed name of testquip exactly matches the text tmp_input_buffer:
				deliver testquip;
				now tmp-found is true;
				break;
		if tmp-found is false:
			[check for most matching words]
			let tmp-best-match be an object;
			let tmp-best-match-count be 0;
			repeat with testquip running through disambiguation-quips:
				let tmp-current-match-count be 0;
				repeat with twordnum1 running from 1 to the number of words in the printed name of testquip:
					repeat with twordnum2 running from 1 to the number of words in tmp_input_buffer:
						if word number twordnum1 in the printed name of testquip exactly matches the text (word number twordnum2 in tmp_input_buffer), increment tmp-current-match-count;
				if tmp-current-match-count > tmp-best-match-count:
					now tmp-found is true;
					now tmp-best-match is testquip;
					now tmp-best-match-count is tmp-current-match-count;
				otherwise if tmp-current-match-count is tmp-best-match-count:
					now tmp-found is false;
			if tmp-found is true:
				[yes, one quip has more matching words than any other]
				deliver tmp-best-match;
			otherwise:
				[no, disambiguation failed]
				follow the disambiguation failure rule. [because phrases can't uses lettered responses]

This is the disambiguation question rule:
	say "What [do] [we] want to discuss, [an or-list of disambiguation-quips]?[paragraph break]" (A);

This is the disambiguation failure rule:
	say "I'm not sure what topic you're referring to." (A);

Section 4.1.3 - Transition statements

Transitioning from it to is an action applying to two visible things.
Transitioning to is an action applying to one visible thing.

Instead of transitioning from something to something, try transitioning to the second noun.

Chapter 4.2 - Quip scope

Section 4.2.1 - Legal topics

A person has a list of objects called legal topics.

Definition: a quip is topic-legal:
	if the interlocutor is not nothing:
		if the number of entries in the legal topics of the interlocutor is 0, yes;
		if the topic category of it is listed in the legal topics of the interlocutor, yes;
		no;
	otherwise:
		yes.
		
Section 4.2.2 - Deliverability

Definition: a quip is deliverable:
	if it is not requirement-legal, no;
	yes.
	
Section 4.2.3 - Relevance

Definition: a quip is relevant:
	if it is deliverable, yes;
	no.
	
Section 4.2.4 - Requirement

A fact is a kind of object. [Defined here so we can use it below]

Quip-requirement relates various quips to various quips. The verb to require the quip (he requires the quip, they require the quip, he required the quip, it is quip-required) implies the quip-requirement relation.

Scene-requirement relates various quips to various scenes. The verb to require the scene (he requires the scene, they require the scene, he required the scene, it is scene-required) implies the scene-requirement relation.

Past-scene-requirement relates various quips to various scenes. The verb to require the past scene (he requires the past scene, they require the past scene, he required the past scene, it is past-scene-required) implies the past-scene-requirement relation.

Fact-requirement relates various quips to various facts. The verb to require the fact (he requires the fact, they require the fact, he required the fact, it is fact-required) implies the fact-requirement relation.

Definition: a quip (called the tested quip) is requirement-legal:
	if the interlocutor is not nothing:
		repeat with tmp-quip running through quips quip-required by the tested quip:
			if tmp-quip is unsaid, no;
		repeat with tmp-scene running through scenes scene-required by the tested quip:
			if tmp-scene is not happening, no;
		repeat with tmp-scene running through scenes past-scene-required by the tested quip:
			if tmp-scene has not happened, no;
		repeat with tmp-fact running through facts fact-required by the tested quip:
			if the interlocutor does not know tmp-fact, no;
		yes;
	otherwise:
		yes.

Book 5 - Quip scheduling

Chapter 5.1 - Scheduling primitives

To schedule (the active quip - a quip):
	if the interlocutor is not nothing:
		if the active quip is listed in the active quip stack of the interlocutor, remove the active quip from the active quip stack of the interlocutor;
		add the active quip to the active quip stack of the interlocutor.

To schedule (the active quip - a quip) as delayed:
	if the interlocutor is not nothing:
		if the active quip is listed in the delayed quip stack of the interlocutor, remove the active quip from the delayed quip stack of the interlocutor;
		add the active quip to the delayed quip stack of the interlocutor.
		
To schedule (the active quip - a quip) topmost:
	if the interlocutor is not nothing:
		if the active quip is listed in the active quip stack of the interlocutor, remove the active quip from the active quip stack of the interlocutor;
		add the active quip at entry 1 in the active quip stack of the interlocutor.

To schedule (the active quip - a quip) topmost as delayed:
	if the interlocutor is not nothing:
		if the active quip is listed in the delayed quip stack of the interlocutor, remove the active quip from the delayed quip stack of the interlocutor;
		add the active quip at entry 1 in the delayed quip stack of the interlocutor.
		
Chapter 5.2 - Advanced shorthands

Section 5.2.1 - Schedule to active stack

To schedule (the active quip - a quip) as automatic:
	now the active quip is automatic;
	schedule the active quip.

To schedule (the active quip - a quip) as obligatory:
	now the active quip is obligatory;
	schedule the active quip.

To schedule (the active quip - a quip) as optional:
	now the active quip is optional;
	schedule the active quip.

To schedule (the active quip - a quip) as unimportant:
	now the active quip is unimportant;
	schedule the active quip.

To schedule (the active quip - a quip) topmost as automatic:
	now the active quip is automatic;
	schedule the active quip topmost.

To schedule (the active quip - a quip) topmost as obligatory:
	now the active quip is obligatory;
	schedule the active quip topmost.

To schedule (the active quip - a quip) topmost as optional:
	now the active quip is optional;
	schedule the active quip topmost.

To schedule (the active quip - a quip) topmost as unimportant:
	now the active quip is unimportant;
	schedule the active quip topmost.

[Conditional scheduling]
To conditionally schedule (the active quip - a quip) as automatic:
	if the active quip is unsaid:
		now the active quip is automatic;
		schedule the active quip.

To conditionally schedule (the active quip - a quip) as obligatory:
	if the active quip is unsaid:
		now the active quip is obligatory;
		schedule the active quip.

To conditionally schedule (the active quip - a quip) as optional:
	if the active quip is unsaid:
		now the active quip is optional;
		schedule the active quip.

To conditionally schedule (the active quip - a quip) as unimportant:
	if the active quip is unsaid:
		now the active quip is unimportant;
		schedule the active quip.

To conditionally schedule (the active quip - a quip) topmost as automatic:
	if the active quip is unsaid:
		now the active quip is automatic;
		schedule the active quip topmost.

To conditionally schedule (the active quip - a quip) topmost as obligatory:
	if the active quip is unsaid:
		now the active quip is obligatory;
		schedule the active quip topmost.

To conditionally schedule (the active quip - a quip) topmost as optional:
	if the active quip is unsaid:
		now the active quip is optional;
		schedule the active quip topmost.

To conditionally schedule (the active quip - a quip) topmost as unimportant:
	if the active quip is unsaid:
		now the active quip is unimportant;
		schedule the active quip topmost.

Section 5.2.2 - Schedule to delayed stack

To schedule (the active quip - a quip) as automatic delayed:
	now the active quip is automatic;
	schedule the active quip as delayed.

To schedule (the active quip - a quip) as obligatory delayed:
	now the active quip is obligatory;
	schedule the active quip as delayed.

To schedule (the active quip - a quip) as optional delayed:
	now the active quip is optional;
	schedule the active quip as delayed.

To schedule (the active quip - a quip) as unimportant delayed:
	now the active quip is unimportant;
	schedule the active quip as delayed.

To schedule (the active quip - a quip) topmost as automatic delayed:
	now the active quip is automatic;
	schedule the active quip topmost as delayed.

To schedule (the active quip - a quip) topmost as obligatory delayed:
	now the active quip is obligatory;
	schedule the active quip topmost as delayed.

To schedule (the active quip - a quip) topmost as optional delayed:
	now the active quip is optional;
	schedule the active quip topmost as delayed.

To schedule (the active quip - a quip) topmost as unimportant delayed:
	now the active quip is unimportant;
	schedule the active quip topmost as delayed.

[Conditional scheduling]
To conditionally schedule (the active quip - a quip) as automatic delayed:
	if the active quip is unsaid:
		now the active quip is automatic;
		schedule the active quip as delayed.

To conditionally schedule (the active quip - a quip) as obligatory delayed:
	if the active quip is unsaid:
		now the active quip is obligatory;
		schedule the active quip as delayed.

To conditionally schedule (the active quip - a quip) as optional delayed:
	if the active quip is unsaid:
		now the active quip is optional;
		schedule the active quip as delayed.

To conditionally schedule (the active quip - a quip) as unimportant delayed:
	if the active quip is unsaid:
		now the active quip is unimportant;
		schedule the active quip as delayed.

To conditionally schedule (the active quip - a quip) topmost as automatic delayed:
	if the active quip is unsaid:
		now the active quip is automatic;
		schedule the active quip topmost as delayed.

To conditionally schedule (the active quip - a quip) topmost as obligatory delayed:
	if the active quip is unsaid:
		now the active quip is obligatory;
		schedule the active quip topmost as delayed.

To conditionally schedule (the active quip - a quip) topmost as optional delayed:
	if the active quip is unsaid:
		now the active quip is optional;
		schedule the active quip topmost as delayed.

To conditionally schedule (the active quip - a quip) topmost as unimportant delayed:
	if the active quip is unsaid:
		now the active quip is unimportant;
		schedule the active quip topmost as delayed.

Book 6 - Tracking the current speaker

Chapter 6.1 - Greetings

To greet (the active person - a person):
	if the interlocutor is not nothing:
		take leave of the interlocutor;
	now the interlocutor is the active person;
	now conversing is true.
	
Greeting is an action applying to one visible thing. Understand "greet [something]" or "say hello/hi to [something]" or "talk to [something]" or "t to [something]" as greeting.
Check greeting when the noun is not a person (this is the can't greet inanimate objects rule):
	instead say "[The noun] [do not respond]." (A).
Check greeting when the noun is the interlocutor (this is the can't greet interlocutor rule):
	instead say "[We]['re] already talking to [the noun]." (A).
Check greeting when the noun is the player (this is the can't greet yourself rule):
	instead say "Talking to [ourselves] [would] [accomplish] little." (A).
Carry out greeting:
	greet the noun.
Report greeting (this is the default greeting rule):
	deliver the greeting quip of the noun.

Implicitly greeting is an action applying to one visible thing.
Carry out implicitly greeting:
	greet the noun.
Report implicitly greeting (this is the default implicit greeting rule):
	if the implicit greeting quip of the noun is not nothing, deliver the implicit greeting quip of the noun.

Hailing is an action applying to nothing. Understand "hello" or "hi" or "greetings" or "say hello/hi/greetings" as hailing.
Check hailing when the number of visible people who are not the player is 0 (this is the can't hail nothing rule):
	instead say "There [are] no one [here] to greet." (A).
Carry out hailing:
	try greeting a random visible person who is not the player.
		
Before asking someone about something when the noun is not the interlocutor, try implicitly greeting the noun.
Before asking someone about the object something when the noun is not the interlocutor, try implicitly greeting the noun.
Before telling someone about something when the noun is not the interlocutor, try implicitly greeting the noun.
Before telling someone about the object something when the noun is not the interlocutor, try implicitly greeting the noun.
Before asking someone for something when the noun is not the interlocutor, try implicitly greeting the noun.
Before asking someone for the text something when the noun is not the interlocutor, try implicitly greeting the noun.
Before showing something to someone when the second noun is not the interlocutor, try implicitly greeting the second noun.
Before showing the text a topic to someone when the second noun is not the interlocutor, try implicitly greeting the second noun.
Before interacting with someone about a topic when the noun is not the interlocutor, try implicitly greeting the noun.
Before interacting with someone about the object something when the noun is not the interlocutor, try implicitly greeting the noun.
Before saying yes to someone when the noun is not the interlocutor, try implicitly greeting the noun.
Before saying no to someone when the noun is not the interlocutor, try implicitly greeting the noun.

Chapter 6.2 - Farewells

To decide if leavetaking is blocked:
	repeat with checkitem running through the active quip stack of the interlocutor:
		if checkitem is obligatory:
			deliver checkitem;
			decide on true;
	repeat with checkitem running through the delayed quip stack of the interlocutor:
		if checkitem is obligatory:
			deliver checkitem;
			decide on true;
	decide on false.
	
Taking leave of is an action applying to one visible thing. Understand "say goodbye/bye/farewell to [something]" or "leave [something]" as taking leave of.
Check taking leave of when leavetaking is blocked (this is the can't take leave after obligatories rule):
	if the noun is the interlocutor, stop the action.
Carry out taking leave of:
	deliver the leavetaking quip of the noun; [delivered here instead of a report rule because "the interlocutor" needs to still be set for the default leavetaking quip]
	if the noun is the interlocutor, take leave of the interlocutor.
	
Implicitly taking leave of is an action applying to one visible thing.
Check implicitly taking leave of when leavetaking is blocked (this is the can't implicitly take leave after obligatories rule):
	if the noun is the interlocutor, stop the action.
Carry out implicitly taking leave of:
	if the implicit leavetaking quip of the noun is not nothing, deliver the implicit leavetaking quip of the noun; [delivered here instead of a report rule because "the interlocutor" needs to still be set for the default leavetaking quip]
	if the noun is the interlocutor, take leave of the interlocutor.

Leavetaking is an action applying to nothing. Understand "goodbye" or "good bye" or "bye" or "farewell" or "so long" or "say goodbye/bye/farewell" or "say good bye" or "say so long" or "stop talking/conversing/discussing" or "leave" or "leave the conversation/discussion" as leavetaking.
Check leavetaking when the interlocutor is nothing (this is the can't take leave of nothing rule):
	instead say "[We]['re] not currently talking to anyone." (A).
Carry out leavetaking:
	try taking leave of the interlocutor.

To take leave of (the active person - a person):
	if conversation-restricted is true, unrestrict conversation;
	now the interlocutor is nothing;
	now conversing is false.
	
This is the motion implies goodbye rule:
	if conversing is true:
		if the interlocutor is not conversationally mobile, try implicitly taking leave of the interlocutor.
The motion implies goodbye rule is listed first in the carry out going rules.

Book 7 - Advanced command syntax

Chapter 7.1 - Extended syntax

Asking it about the object is an action applying to two visible things.
Understand the command "ask" as something new.
Understand "ask [someone] about [text]" as asking it about.
Understand "ask [someone] about [any known thing]" as asking it about the object.

Telling it about the object is an action applying to two visible things.
Understand the command "tell" as something new.
Understand "tell [someone] about [text]" as telling it about.
Understand "tell [someone] about [any known thing]" as telling it about the object.

Asking it for the text is an action applying to one visible thing and one topic.
Understand "ask [someone] for [any known thing]" as asking it for.
Understand "ask [someone] for [text]" as asking it for the text.

Showing the text it to is an action applying to one topic and one visible thing.
Understand "show [any known thing] to [someone]" as showing it to.
Understand "show [text] to [someone]" as showing the text it to.

Instead of answering someone (called the active person) that a topic (called the active topic), try telling the active person about the the active topic.

Chapter 7.2 - Generic "interacting with" action

Interacting with it about is an action applying to one visible thing and one topic.
Interacting with it about the object is an action applying to two visible things.

Instead of asking someone (called the active person) about a topic (called the active topic), try interacting with the active person about the active topic.
Instead of asking someone (called the active person) about the object something (called the active object), try interacting with the active person about the object the active object.
Instead of telling someone (called the active person) about a topic (called the active topic), try interacting with the active person about the active topic.
Instead of telling someone (called the active person) about the object something (called the active object), try interacting with the active person about the object the active object.
Instead of showing something (called the active object) to someone (called the active person), try interacting with the active person about the object the active object.
Instead of showing the text a topic (called the active topic) to someone (called the active person), try interacting with the active person about the active topic.

Chapter 7.3 - Special commands

Saying yes to is an action applying to one visible thing.
Saying no to is an action applying to one visible thing.

Understand "say yes/yep/indeed/obviously/definitely/true/sure to [someone]" or "tell [someone] yes/yep/indeed/obviously/definitely/true/sure" as saying yes to.
Understand "say no/nope/nah/false to [someone]" or "tell [someone] no/nope/nah/false" as saying no to.

Instead of saying yes to someone (called the active person):
	deliver the default response quip of the active person.
Instead of saying no to someone (called the active person):
	deliver the default response quip of the active person.

Chapter 7.4 - Commands with an implicit interlocutor

To check the interlocutor: follow the interlocutor checking procedure rule.

This is the interlocutor checking procedure rule:
	if the interlocutor is nothing:
		let np be the list of people who can see the player;
		remove the list of conversation masterminds from np;
		remove the player from np;
		if the number of entries in np is 0:
			say "[There's] no one [here] to talk to." (A);
		otherwise if the number of entries in np is 1:
			let the temporary interlocutor be entry 1 in np;
			say "(addressing [the temporary interlocutor])" (B);
			try implicitly greeting the temporary interlocutor;
		otherwise:
			say "You need to specify who [we]['re] [present participle of the verb speak] to." (C).

Implicitly asking about is an action applying to one topic.
Implicitly asking about the object is an action applying to one visible thing.
Understand "ask about [text]" as implicitly asking about.
Understand "ask about [any known thing]" as implicitly asking about the object.

Instead of implicitly asking about a topic (called the active topic):
	check the interlocutor;
	if the interlocutor is not nothing:
		try asking the interlocutor about the active topic.
Instead of implicitly asking about the object something (called the active object):
	check the interlocutor;
	if the interlocutor is not nothing:
		try asking the interlocutor about the object the active object.

Implicitly telling about is an action applying to one topic.
Implicitly telling about the object is an action applying to one visible thing.
Understand "tell about [text]" as implicitly telling about.
Understand "tell about [any known thing]" as implicitly telling about the object.

Instead of implicitly telling about a topic (called the active topic):
	check the interlocutor;
	if the interlocutor is not nothing:
		try telling the interlocutor about the active topic.
Instead of implicitly telling about the object something (called the active object):
	check the interlocutor;
	if the interlocutor is not nothing:
		try telling the interlocutor about the object the active object.
		
Implicitly asking for is an action applying to visible thing.
Implicitly asking for the text is an action applying to one topic.
Understand "ask for [any known thing]" as implicitly asking for.
Understand "ask for [text]" as implicitly asking for the text.

Instead of implicitly asking for something (called the active object):
	check the interlocutor;
	if the interlocutor is not nothing:
		try asking the interlocutor for the active object.
Instead of implicitly asking for the text a topic (called the active topic):
	check the interlocutor;
	if the interlocutor is not nothing:
		try asking the interlocutor for the text the active topic.
		
Implicitly showing is an action applying to one visible thing.
Implicitly showing the text is an action applying to one topic.
Understand "show [any known thing]" as implicitly showing.
Understand "show [text]" as implicitly showing the text.

Instead of implicitly showing something (called the active object):
	check the interlocutor;
	if the interlocutor is not nothing:
		try showing the active object to the interlocutor.
Instead of implicitly showing the text a topic (called the active topic):
	check the interlocutor;
	if the interlocutor is not nothing:
		try showing the text the active topic to the interlocutor.

Implicitly saying yes is an action applying to nothing.
Implicitly saying no is an action applying to nothing.

Understand the command "yes" as something new. Understand the command "no" as something new.
Understand "yes" or "yep" or "yup" or "indeed" or "of course" or "obviously" or "definitely" or "true" or "sure" or "sure thing" or "say yes/yep/indeed/obviously/definitely/true/sure" or "say of course" or "say sure thing" as implicitly saying yes.
Understand "no" or "nope" or "nah" or "false" or "say no/nope/nah/false" as implicitly saying no.

Instead of implicitly saying yes:
	check the interlocutor;
	if the interlocutor is not nothing:
		try saying yes to the interlocutor.
Instead of implicitly saying no:
	check the interlocutor;
	if the interlocutor is not nothing:
		try saying no to the interlocutor.

Chapter 7.5 - Command synonyms

Understand "question [someone] about [text]" as asking it about.
Understand "question [someone] about [any known thing]" as asking it about the object.
Understand "query [someone] about [text]" as asking it about.
Understand "query [someone] about [any known thing]" as asking it about the object.
Understand "quiz [someone] about [text]" as asking it about.
Understand "quiz [someone] about [any known thing]" as asking it about the object.
Understand "quiz [someone] over [text]" as asking it about.
Understand "quiz [someone] over [any known thing]" as asking it about the object.
Understand "quiz [someone] on [text]" as asking it about.
Understand "quiz [someone] on [any known thing]" as asking it about the object.
Understand "inquire of [someone] about [text]" as asking it about.
Understand "inquire of [someone] about [any known thing]" as asking it about the object.
Understand "discuss [text] with [someone]" as asking it about (with nouns reversed).
Understand "discuss [any known thing] with [someone]" as asking it about the object (with nouns reversed).
Understand "inquire about [any known thing]" as implicitly asking about the object.
Understand "inquire about [text]" as implicitly asking about.
Understand "talk about [text]" as implicitly asking about.
Understand "talk about [any known thing]" as implicitly asking about the object.
Understand "ask [someone] [text]" as asking it about.
Understand "ask [someone] [any known thing]" as asking it about the object.
Understand "ask [text]" as implicitly asking about.
Understand "ask [any known thing]" as implicitly asking about the object.
Understand "a [someone] [text]" as asking it about.
Understand "a [someone] [any known thing]" as asking it about the object.
Understand "a [text]" as implicitly asking about.
Understand "a [any known thing]" as implicitly asking about the object.
Understand "discuss [text]" as implicitly asking about.
Understand "discuss [any known thing]" as implicitly asking about the object.

Understand "inform [someone] about [text]" as telling it about.
Understand "inform [someone] about [any known thing]" as telling it about the object.
Understand "educate [someone] on/that [text]" as telling it about.
Understand "educate [someone] on/that [any known thing]" as telling it about the object.
Understand "inform [someone] [text]" as telling it about.
Understand "inform [someone] [any known thing]" as telling it about the object.
Understand "state that [text]" as implicitly telling about.
Understand "state that [any known thing]" as implicitly telling about the object.
Understand "tell [someone] [text]" as telling it about.
Understand "tell [someone] [any known thing]" as telling it about the object.
Understand "tell [text]" as implicitly telling about.
Understand "tell [any known thing]" as implicitly telling about the object.
Understand "t [someone] about [text]" as telling it about.
Understand "t [someone] about [any known thing]" as telling it about the object.
Understand "t [someone] [text]" as telling it about.
Understand "t [someone] [any known thing]" as telling it about the object.
Understand "t [text]" as implicitly telling about.
Understand "t [any known thing]" as implicitly telling about the object.

Understand "present [text] to [someone]" as showing the text it to.
Understand "present [any known thing] to [someone]" as showing it to.
Understand "demonstrate [text] to [someone]" as showing the text it to.
Understand "demonstrate [any known thing] to [someone]" as showing it to.
Understand "present [text]" as implicitly showing the text.
Understand "present [any known thing]" as implicitly showing.
Understand "demonstrate [text]" as implicitly showing the text.
Understand "demonstrate [any known thing]" as implicitly showing.
Understand "bring out [text]" as implicitly showing the text.
Understand "bring out [any known thing]" as implicitly showing.

Understand "a [someone] for [text]" as asking it for the text.
Understand "a [someone] for [any known thing]" as asking it for.
Understand "request [text] from [someone]" as asking it for the text (with nouns reversed).
Understand "request [any known thing] from [someone]" as asking it for (with nouns reversed).
Understand "ask for [text] from [someone]" as asking it for the text (with nouns reversed).
Understand "ask for [any known thing] from [someone]" as asking it for (with nouns reversed).
Understand "a for [text] from [someone]" as asking it for the text (with nouns reversed).
Understand "a for [any known thing] from [someone]" as asking it for (with nouns reversed).
Understand "request [text]" as implicitly asking for the text.
Understand "request [any known thing]" as implicitly asking for.
Understand "ask for [text]" as implicitly asking for the text.
Understand "ask for [any known thing]" as implicitly asking for.
Understand "a for [text]" as implicitly asking for the text.
Understand "a for [any known thing]" as implicitly asking for.

Chapter 7.6 - Resolving undefined queries

A person has a list of objects called the speakerlist.

When play begins:
	if the manual quip-matching only option is not active:
		repeat with active quip running through quips:
			if the speaker of the active quip is not nothing:
				add the active quip to (the speakerlist of the speaker of the active quip).

Carry out interacting with someone (called the active person) about a topic:
	if the manual quip-matching only option is active:
		deliver the default response quip of the active person;
	otherwise:
		let templist be a list of quips;
		let templist-final be a list of quips;
		let templist-number be a list of numbers;
		let tempnumber-max be a number;
		repeat with active quip running through the speakerlist of the active person:
			let tempnumber be the number of words in the topic understood that match the keywords ask words of the active quip;
			if tempnumber is greater than 0:
				add the active quip to templist;
				add tempnumber to templist-number;
				if tempnumber is greater than tempnumber-max:
					now tempnumber-max is tempnumber;
		repeat with tmpticker running from 1 to the number of entries in templist:
			if entry tmpticker of templist-number is tempnumber-max, add entry tmpticker of templist to templist-final;
		disambiguate the quips templist-final.

Carry out interacting with someone (called the active person) about the object something (called the active object):
	if the manual quip-matching only option is active:
		deliver the default response quip of the active person;
	otherwise:
		let templist be a list of quips;
		repeat with active quip running through the speakerlist of the active person:
			if the active object is listed in the ask objects of the active quip:
				add the active quip to templist;
		disambiguate the quips templist.

Chapter 7.7 - Defining conversation actions

To decide if actively conversing:
	if the current action is interacting with someone about a topic, yes;
	if the current action is interacting with someone about the object something, yes;
	if the current action is telling someone about a topic, yes;
	if the current action is telling someone about the object something, yes;
	if the current action is asking someone about a topic, yes;
	if the current action is asking someone about the object something, yes;
	if the current action is showing something to someone, yes;
	if the current action is showing the text a topic to someone, yes;
	if the current action is asking someone for something, yes;
	if the current action is asking someone for the text a topic, yes;
	if the current action is saying yes to someone, yes;
	if the current action is saying no to someone, yes;
	if the current action is implicitly telling about a topic, yes;
	if the current action is implicitly telling about the object something, yes;
	if the current action is implicitly asking about a topic, yes;
	if the current action is implicitly asking about the object something, yes;
	if the current action is implicitly showing something, yes;
	if the current action is implicitly showing the text a topic, yes;
	if the current action is implicitly asking for something, yes;
	if the current action is implicitly asking for the text a topic, yes;
	if the current action is implicitly saying yes, yes;
	if the current action is implicitly saying no, yes;
	if the current action is hailing, yes;
	if the current action is greeting someone, yes;
	if the current action is implicitly greeting someone, yes;
	if the current action is leavetaking, yes;
	if the current action is taking leave of someone, yes;
	if the current action is implicitly taking leave of someone, yes;
	no.
	
To decide if responding to a query:
	if on-first-quip is true and actively conversing, yes;
	no.

Book 8 - Defaults

Instead of asking a female person about "herself", try asking the noun about the object the noun.
Instead of asking a male person about "himself", try asking the noun about the object the noun.

The global default response quip is a quip. "[The interlocutor] [do not react].".
A person has an object called the default response quip. The default response quip of a person is usually the global default response quip.

The global greeting quip is a quip. "[We] [greet] [the interlocutor].".
A person has an object called the greeting quip. The greeting quip of a person is usually the global greeting quip.
A person has an object called the implicit greeting quip. The implicit greeting quip of a person is usually nothing.

The global leavetaking quip is a quip. "[We] [say] goodbye to [the interlocutor].".
A person has an object called the leavetaking quip. The leavetaking quip of a person is usually the global leavetaking quip.
A person has an object called the implicit leavetaking quip. The implicit leavetaking quip of a person is usually nothing.

Book 9 - Restrictions

flag-restriction-examining is a truth state that varies.
flag-restriction-movement is a truth state that varies.
flag-restriction-taking is a truth state that varies.
flag-restriction-dropping is a truth state that varies.
flag-restriction-general is a truth state that varies.
flag-restriction-conversation is a truth state that varies.
	
The legal actions list is a list of stored actions that varies.
Conversation-restricted is a truth state that varies.
The restriction quip is an object that varies.

The check conversation restrictions rule is listed before the access through barriers rule in the accessibility rulebook.

To decide if the current action is conversationally restricted:
	if the current action is transitioning from something to something, no;
	if the current action is listed in the legal actions list, no;
	if flag-restriction-examining is true and the current action is examining, no;
	if flag-restriction-movement is true and the current action is going, no;
	if flag-restriction-taking is true and the current action is taking, no;
	if flag-restriction-dropping is true and the current action is dropping, no;
	if flag-restriction-general is true and not actively conversing, no;
	if flag-restriction-conversation is true and actively conversing, no;
	yes.

The last before rule (this is the check conversation restrictions rule):
	if conversation-restricted is true:
		if the current action is conversationally restricted:
			deliver the restriction quip;
			stop the action;
		otherwise:
			continue the action.
			
To restrict conversation with (the active quip - a quip):
	now flag-restriction-examining is false;
	now flag-restriction-movement is false;
	now flag-restriction-taking is false;
	now flag-restriction-dropping is false;
	now flag-restriction-general is false;
	now flag-restriction-conversation is false;
	truncate the legal actions list to 0 entries;
	now the restriction quip is the active quip;
	now conversation-restricted is true.
	
To unrestrict conversation:
	now conversation-restricted is false.
	
To permit (the active action - a stored action): add the active action to the legal actions list.
To permit examining: now flag-restriction-examining is true.
To permit movement:
	now flag-restriction-movement is true;
	permit leavetaking.
To permit leavetaking:
	permit the action of leavetaking;
	if the interlocutor is not nothing:
		permit the action of taking leave of the interlocutor;
		permit the action of implicitly taking leave of the interlocutor.
To permit taking: now flag-restriction-taking is true.
To permit dropping: now flag-restriction-dropping is true.
To permit movement but not leavetaking: now flag-restriction-movement is true.
To permit non-conversation actions: now flag-restriction-general is true.
To permit conversation actions: now flag-restriction-conversation is true.

To restrict conversation to yes-no with (the active quip - a quip):
	restrict conversation with the active quip;
	permit the action of saying yes to the interlocutor;
	permit the action of saying no to the interlocutor;
	permit the action of implicitly saying yes;
	permit the action of implicitly saying no.
		
Book 10 - Factual information

[A fact is a kind of object.] [Defined above.]

Factual knowledge relates various people to various facts. The verb to know (he knows, they know, he knew, it is known) implies the factual knowledge relation.

To publicly announce (the active fact - a fact):
	now the player knows the active fact;
	now every person who can see the player knows the active fact.
To globally announce (the active fact - a fact):
	now the player knows the active fact;
	now every visible person knows the active fact.
Before printing the name of a fact (called the active fact):
	publicly announce the active fact.
Rule for printing the name of a fact:
	do nothing instead.
	
To forget (the active fact - a fact):
	now the player does not know the active fact;
	now every person who can see the player does not know the active fact.
To globally forget (the active fact - a fact):
	now the player does not know the active fact;
	now every visible person does not know the active fact.
To say forget (the active fact - a fact):
	forget the active fact.
	
Book 11 - Suggested topics

Chapter 11.1 - Building suggestion lists

A person has a list of objects called the suggested topics list.
A person has a list of objects called the suggested subject change list.
A person has a list of objects called the added topic suggestions list.
A person has a list of objects called the added subject change suggestions list.

To suggest (the active quip - a quip) for (the active person - a person):
	if the active quip is not listed in the suggested topics list of the active person:
		add the active quip to the suggested topics list of the active person;
		if suggest-topics-after-additions is true:
			if the active quip is not listed in the added topic suggestions list of the active person, add the active quip to the added topic suggestions list of the active person.
To suggest the subject change (the active quip - a quip) for (the active person - a person):
	if the active quip is not listed in the suggested subject change list of the active person:
		add the active quip to the suggested subject change list of the active person;
		if suggest-topics-after-additions is true:
			if the active quip is not listed in the added subject change suggestions list of the active person, add the active quip to the added subject change suggestions list of the active person.

To suggest (the active quip - a quip):
	if the interlocutor is not nothing, suggest the active quip for the interlocutor.
To suggest the subject change (the active quip - a quip):
	if the interlocutor is not nothing, suggest the subject change the active quip for the interlocutor.

To unsuggest (the active quip - a quip) for (the active person - a person):
	remove the active quip from the suggested topics list of the active person.
To unsuggest the subject change (the active quip - a quip) for (the active person - a person):
	remove the active quip from the suggested subject change list of the active person.

To unsuggest (the active quip - a quip):
	if the interlocutor is not nothing, unsuggest the active quip for the interlocutor.
To unsuggest the subject change (the active quip - a quip):
	if the interlocutor is not nothing, unsuggest the subject change the active quip for the interlocutor.
	
Chapter 11.2 - Suggesting topics

The available topic suggestions is a list of quips that varies.
The available subject change suggestions is a list of quips that varies.
The currently related topics is a list of objects that varies.

List-suggestions-as-one-paragraph is a truth state that varies.
	
To compile currently related topics:
	truncate the currently related topics to 0 entries;
	add the conversation topic of the interlocutor to the currently related topics;
	add the list of objects that are a subtopic of the conversation topic of the interlocutor to the currently related topics;
	if the conversation topic of the interlocutor is a subtopic of something:
		add the parent topic of the conversation topic of the interlocutor to the currently related topics;
		add the list of objects that are a subtopic of the parent topic of the conversation topic of the interlocutor to the currently related topics.

To compile available topic suggestions:
	truncate the available topic suggestions to 0 entries;
	truncate the available subject change suggestions to 0 entries;
	if the interlocutor is not nothing:
		compile currently related topics;
		repeat with active quip running through the suggested topics list of the interlocutor:
			if the topic category of the active quip is listed in the currently related topics:
				if the active quip is deliverable and the active quip is topic-legal and the active quip is unsaid, add the active quip to the available topic suggestions;
		repeat with active quip running through the suggested subject change list of the interlocutor:
			if the active quip is deliverable and the active quip is topic-legal and the active quip is unsaid, add the active quip to the available subject change suggestions.
			
To output available topic suggestions: follow the suggestion procedure rule.

This is the suggestion procedure rule:
	if the number of entries in the available topic suggestions is 0 and the number of entries in the available subject change suggestions is 0:
		say "[We] [can't think] of anything in particular to discuss right [now]." (A);
	otherwise:
		if list-suggestions-as-one-paragraph is true:
			if the number of entries in the available topic suggestions is not 0 and the number of entries in the available subject change suggestions is not 0:
				say "[We] [could] discuss [an or-list of the available topic suggestions][if the number of entries in the available topic suggestions is greater than 1]; or, [else], or [end if][we] [could] change the subject to [an or-list of the available subject change suggestions]." (B);
			otherwise:
				if the number of entries in the available topic suggestions is not 0, say "[We] could [discuss] [an or-list of the available topic suggestions]." (C);
				if the number of entries in the available subject change suggestions is not 0, say "[We] could [discuss] [an or-list of the available subject change suggestions]." (D);
		otherwise:
			if the number of entries in the available topic suggestions is not 0, say "[We] could [discuss] [an or-list of the available topic suggestions]." (E);
			if the number of entries in the available subject change suggestions is not 0:
				say "[if the number of entries in the available topic suggestions is not 0][line break]Or, [we] could [change] the subject to[otherwise][We] could [discuss][end if] [an or-list of the available subject change suggestions]." (F).
			
To suggest conversation topics:
	compile available topic suggestions;
	output available topic suggestions.
	
To conditionally suggest conversation topics:
	compile available topic suggestions;
	if the number of entries in the available topic suggestions is not 0 or the number of entries in the available subject change suggestions is not 0, output available topic suggestions.

Chapter 11.3 - Actions triggering suggestions

Section 11.3.1 - Direct requests

Requesting topic suggestions is an action applying to nothing. Understand "topics" or "things to say" or "things to talk about" or "suggest" or "suggestion" or "suggestions" or "suggest topics" or "suggest things to say" or "suggest things to talk about" or "what should I say" or "what can I say" or "list topics" or "list things to say" or "list things to talk about" as requesting topic suggestions.
Check requesting topic suggestions (this is the can't request suggestions when not conversing rule): if conversing is false, instead say "[We]['re] not currently talking to anyone." (A).
Carry out requesting topic suggestions: suggest conversation topics.

Section 11.3.2 - After every conversation action

Suggest-topics-after-conversing is a truth state that varies.
Every turn when conversing is true and suggest-topics-after-conversing is true (this is the suggesting topics after conversation rule):
	if actively conversing, conditionally suggest conversation topics.

Section 11.3.3 - After inactivity

Suggest-topics-after-inactivity is a truth state that varies.
Topic-suggestion-delay is a number that varies. Topic-suggestion-delay is 3.
Topic-suggestion-ticker is a number that varies. Topic-suggestion-ticker is 0.

Every turn when conversing is true and suggest-topics-after-inactivity is true (this is the suggesting topics after inactivity rule):
	if actively conversing:
		now topic-suggestion-ticker is 0;
	otherwise:
		increment topic-suggestion-ticker;
		if topic-suggestion-ticker is topic-suggestion-delay or topic-suggestion-ticker is greater than topic-suggestion-delay:
			now topic-suggestion-ticker is 0;
			conditionally suggest conversation topics.

Section 11.3.4 - After additions

Suggest-topics-after-additions is a truth state that varies.

Every turn when conversing is true and suggest-topics-after-additions is true (this is the suggesting topics after additions rule):
	if the number of entries in the added topic suggestions list of the interlocutor is not 0 or the number of entries in the added subject change suggestions list of the interlocutor is not 0:
		truncate the available topic suggestions to 0 entries;
		truncate the available subject change suggestions to 0 entries;
		compile currently related topics;
		repeat with active quip running through the added topic suggestions list of the interlocutor:
			if the topic category of the active quip is listed in the currently related topics:
				if the active quip is deliverable and the active quip is topic-legal and the active quip is unsaid, add the active quip to the available topic suggestions;
		repeat with active quip running through the added subject change suggestions list of the interlocutor:
			if the active quip is deliverable and the active quip is topic-legal and the active quip is unsaid, add the active quip to the available subject change suggestions;
		if the number of entries in the available topic suggestions is not 0 or the number of entries in the available subject change suggestions is not 0, output available topic suggestions;
		truncate the added topic suggestions list of the interlocutor to 0 entries;
		truncate the added subject change suggestions list of the interlocutor to 0 entries.

Chapter 11.4 - Topic relations

Topic-connection relates various things to one thing (called the parent topic). The verb to be a subtopic of implies the topic-connection relation.

Book 12 - Group conversations

Chapter 12.1 - Conversation masterminds

A conversation mastermind is a kind of person.

After deciding the scope of the player (this is the place masterminds in scope rule):
	repeat with active NPC running through people in the location of the player:
		if the group conversation stand-in of the active NPC is not nothing, place the group conversation stand-in of the active NPC in scope.
A rule for reaching inside a room (this is the allow access to masterminds rule):
	if the person reaching is the player:
		if the noun is a conversation mastermind, allow access;
		if the second noun is a conversation mastermind, allow access.

Chapter 12.2 - Redirection rules

Instead of asking someone about a topic when the group conversation stand-in of the noun is not nothing: try asking the group conversation stand-in of the noun about the topic understood.
Instead of asking someone about the object something when the group conversation stand-in of the noun is not nothing: try asking the group conversation stand-in of the noun about the object the second noun.
Instead of telling someone about a topic when the group conversation stand-in of the noun is not nothing: try telling the group conversation stand-in of the noun about the topic understood.
Instead of telling someone about the object something when the group conversation stand-in of the noun is not nothing: try telling the group conversation stand-in of the noun about the object the second noun.
Instead of showing something to someone when the group conversation stand-in of the second noun is not nothing: try showing the noun to the group conversation stand-in of the second noun.
Instead of showing the text a topic to someone when the group conversation stand-in of the second noun is not nothing: try showing the text the topic understood to the group conversation stand-in of the second noun.
Instead of asking someone for something when the group conversation stand-in of the noun is not nothing: try asking the group conversation stand-in of the noun for the second noun.
Instead of asking someone for the text something when the group conversation stand-in of the noun is not nothing: try asking the group conversation stand-in of the noun for the text the topic understood.

Instead of interacting with someone about a topic when the group conversation stand-in of the noun is not nothing: try interacting with the group conversation stand-in of the noun about the topic understood.
Instead of interacting with someone about the object something when the group conversation stand-in of the noun is not nothing: try interacting with the group conversation stand-in of the noun about the object the second noun.

Instead of saying yes to someone when the group conversation stand-in of the noun is not nothing: try saying yes to the group conversation stand-in of the noun.
Instead of saying no to someone when the group conversation stand-in of the noun is not nothing: try saying no to the group conversation stand-in of the noun.

Instead of greeting someone when the group conversation stand-in of the noun is not nothing: try greeting the group conversation stand-in of the noun.
Instead of implicitly greeting someone when the group conversation stand-in of the noun is not nothing: try implicitly greeting the group conversation stand-in of the noun.

Instead of taking leave of someone when the group conversation stand-in of the noun is not nothing: try taking leave of the group conversation stand-in of the noun.
Instead of implicitly taking leave of someone when the group conversation stand-in of the noun is not nothing: try implicitly taking leave of the group conversation stand-in of the noun.

Stacked Conversation ends here.



---- DOCUMENTATION ----

Chapter: Overview

Traditional ASK/TELL-based conversation systems often feel like looking up entries in a book: the player queries a character about a topic, and they cough up a single canned response and fall silent again. This works, at least from a gameplay standpoint, but it doesn't feel natural. It lacks context and flow -- there's no clear sense of where a conversation came from and where it's going, and the whole thing generally feels one-sided.

Stacked Conversation solves these problems in two ways: first, it provides a set of tools for tracking the context of a conversation and varying behavior accordingly; and second, it provides a way to create chains of responses, so characters can continue conversations without being prodded by the player. In addition, it lets us guide conversation towards specific topics, to ensure that the player hears all the information they need before proceeding.

Some examples of things we can do:

	- Have characters interpret queries differently in different contexts.
	- Have characters acknowledge interruptions and changes of subject.
	- Have characters continue talking about a subject without prompting.
	- Have characters bring up new topics when they run out of things to say.
	- Have characters draw conclusions from facts that come up.
	- Have characters discuss topics in group settings.
	- Force the player to answer a question before moving on.
	- Force the player to hear specific information before a conversation ends.
	- Give the player suggestions on what to discuss next.
	- Give characters a distinct personality and conversational style.
	
Stacked Conversation also greatly expands the vocabulary and syntax the player can use to converse with NPCs by implementing greetings and farewells, commands with implicit interlocutors, ways to converse about objects and abstract subjects as well as keywords, and numerous alternate ways to phrase commands.

Chapter: Conversational Model

Section: Tracking the Speaker

Stacked Conversation assumes the player is only conversing with one character at a time (but see Conversing With Multiple Characters, below). The current interlocutor is tracked automatically: talking with an NPC initates conversation, and walking away or switching to another NPC ends it. Players can also use commands like GREET or SAY GOODBYE TO to explicitly control conversation.

When speaking to an NPC, the player can simply use "ask about (something)" and the like, without explicitly stating whom they are talking to. (In addition, Stacked Conversation implements a large number of synonyms for commands, like "request (something) from (someone)" or "inform (someone) about (something)".)

Section: Quips

Central to the conversation model is the idea of a "quip". A quip is a single action -- usually, a single line of dialogue that an NPC speaks, with some additional actions that affect the flow of the conversation. All conversations are made up of many individual quips linked together.

Quips are a kind of object, so we can define as many quips as we like. The simplest quip is just an object definition followed by some text to say:

	quip-violins is a quip. "Bob looks around at the piles of miniature violins strewn across his garden. 'I'm not sure where they all came from,' he says. 'They just appeared one day.'".

More complicated quips can use a "listing" rule to define a series of actions to take:

	quip-violins is a quip. The topic category is garden ornaments.
	Listing quip-violins:
		say "Bob looks around at the piles of miniature violins strewn across his garden. 'I'm not sure where they all came from,' he says. 'They just appeared one day.'";
		schedule quip-atom-bomb as optional;
		schedule quip-honeybees as optional.
		
(We'll see more about topics and scheduling later.)

Section: Triggering Quips

Quips can be triggered automatically or manually. The automatic way is simple; we define a "speaker" for the quip, and a set of objects and/or text keywords associated with it:

	quip-violins is a quip. "Bob looks around at the piles of miniature violins strewn across his garden. 'I'm not sure where they all came from,' he says. 'They just appeared one day.'".
	The speaker is Bob.
	Ask objects are { the violins, the garden }.
	Ask words are { "violin", "violins", "miniature", "garden" }.
	
Now, if we ASK BOB ABOUT (or TELL, or SHOW) any of the objects or words associated with the quip, the quip will trigger. For example:

	> ASK BOB ABOUT VIOLINS
	Bob looks around at the piles of miniature violins strewn across his garden. "I'm not sure where they all came from," he says. "They just appeared one day."

If more than one usable quip matches, Stacked Conversation will pick the one with the most matching keywords, or ask the player to clarify. (This is done using the disambiguation procedure described in Queries With Multiple Possibilities, below.)

This matching process is necessarily a bit fuzzy; if the player types ASK BOB ABOUT HIS VIOLIN TEACHER, and we haven't written a more specific quip that matches "teacher" as well as "violin", Stacked Conversation might decide that the miniature-violins quip is the closest match and run with it -- even though the player is clearly referring to something else. Moreover, because disambiguation prioritizes unsaid quips over quips that have already been used, typing the same query multiple times might result in several different interpretations. In most cases, however, the matching algorithm does a good job of producing responses that make sense to the player.

If we want more flexibility, we can override the keyword-matching system with manual "instead of..." rules that trigger quips with the "deliver" phrase, like so:

	Instead of asking Bob about "violins", deliver quip-violins.

Stacked Conversation implements many more ways to interact with characters than the Standard Rules. We can ASK ABOUT and TELL ABOUT objects and abstract subjects as well as text keywords; these are mapped to the actions "asking (someone) about the object (something)" and "telling (someone) about the object (something)":

	Grannie's teapot is on Bob's armchair. Instead of asking Bob about the object Grannie's teapot, deliver quip-teapot.
	Philosophy is a subject. Instead of telling Bob about the object philosophy, deliver quip-philosophy.
	
(Stacked Conversation borrows the concept of a "subject" from Epistemology by Eric Eve, which it is compatable with but does not require. A "subject" is basically just a kind of object, representing an abstract idea that doesn't have a physical presence in the game world.)

Similarly, we can SHOW TO and ASK FOR text keywords as well as objects; these are mapped to the actions "showing the text (something) to (someone)" and "asking (someone) for the text (something)":
	
	Instead of asking Bob for the text "forgiveness", deliver quip-you-killed-my-father.
	Instead of showing the text "no mercy" to Bob, deliver quip-ra-ra-melodrama.

For efficiency, unhandled ASK ABOUT, TELL ABOUT, and SHOW TO commands are redirected to the generic actions "interacting with (someone) about (something)" and "interacting with (someone) about the object (something)". This allows us to use the same response for all three commands:

	Instead of interacting with Bob about "justice", deliver quip-philosophical-objection.
	Instead of interacting with Bob about the object Grannie's teapot, deliver quip-teapot.
	
Similarly, the obscure "answering (someone) that (something)" action from the Standard Rules is redirected to the "telling (someone) about (something)" action unless otherwise handled, making ANSWER functionally equivalent to TELL by default.

Section: Active and Delayed Stacks

Stacked Conversation is built around the idea of conversational "threads", where individual quips chain into each other to create a seamless flow within and between topics. To accomplish this, every NPC in the game has two stacks: an Active stack and a Delayed stack. Broadly, the Active stack contains quips relevant to the current topic of conversation, and the Delayed stack contains quips that may be brought up at a later time. Both stacks start out empty, but triggering a quip may add other quips to them.

If an NPC needs something to say (for example, to continue the conversation while the player does something else), it will pull the first entry from its Active stack (unless other priority rules intervene -- see below). If the Active stack is empty, it will pull the first entry from its Delayed stack. If the Delayed stack is also empty, it will select a random Unsaid quip that passes its deliverability test (see below) and is defined as "randomly-deliverable" (e.g.: "quip-snails is a quip. It is randomly-deliverable.") These rules allow NPCs to carry on a natural flow of conversation, switching topics as they run out of things to say.

Section: Quip Priorities

Quips can have four priorities that determine how they are handled in a stack: Automatic, Obligatory, Optional, and Unimportant. These priorities can be changed on demand, as quips become relevant to the conversation.

"Automatic" quips will be delivered automatically in the upcoming turns, even if the player triggers other quips as well. This is useful if we want a conversation thread to continue immediately without the player changing the topic.

"Obligatory" quips MUST come up before the conversation terminates; if the player attempts to end the conversation while there are still Obligatory quips on either stack, the game will refuse, and the NPC will jump directly to the next Obligatory quip. This is useful if we have certain information that must be conveyed before the conversation finishes.

"Optional" quips can be skipped if the player terminates the conversation or takes it in another direction. This is useful to flesh out conversations with non-essential "flavor" dialogue.

"Unimportant" quips (the default) have no particular significance. If placed on one of the stacks, they behave like Optional quips; otherwise, the game just ignores their existence. This is useful for storing quips that haven't yet become relevant to the conversation.

Here's an example of how we can use stacks and priorities to create a simple conversation thread. Suppose the player types:

	> ASK BOB ABOUT SNAILS
	
In response, we might trigger quip-snails. Bob rambles about snails for a bit, and then schedules several more quips:

	schedule quip-snails-2 as optional;
	schedule quip-snails-3 as optional;
	schedule quip-animal-rights as optional delayed;
	schedule quip-dinner as obligatory delayed.
	
If the player doesn't immediately change the subject, Bob will continue talking about snails with quip-snails-2 and quip-snails-3. (Otherwise, Bob will happily forget about them and trigger quips for the new subject.) If Bob runs out of things to say, he may decide to bring up animal rights or (later) dinner. However, he MUST bring up dinner before the conversation ends. Any of these quips might schedule additional quips, as appropriate: for example, quip-animal-rights could schedule a whole new set of Optional quips about animal rights.

Section: Topic Categories

Every quip has a "topic category", which is used to keep conversations from jumping erratically between subjects. When the conversation heads in a new direction, any leftover Optional quips from the previous topic are pruned from the Active stack.

Topic categories are just objects, so we can set a quip's topic category to a physical object that exists in the game world, or we can create an abstract "subject" that represents it:

	The teapot is a container.
	Quip-tea-pour is a quip. The topic category is the teapot.
	
	Justice is a subject.
	Quip-american-way is a quip. The topic category is justice.

By default, the topic category of a quip is "nothing". Topicless quips do not change the current topic of the conversation or prune entries as above, which makes them useful for one-off remarks that don't otherwise affect the flow of discussion. (However, we must be careful when writing one-off remarks: a blithe comment about the weather may be appropriate when walking down the street, but perhaps not when attending a funeral. Write context-sensitive logic as needed.)

Chapter: Working With Conversations

Section: Scheduling Quips

We have already briefly seen how to schedule quips, above. This is accomplished with simple phrases; we can either schedule a quip as-is, or specify a priority level at the same time:

	schedule (quip)
	schedule (quip) as automatic
	schedule (quip) as obligatory
	schedule (quip) as optional
	schedule (quip) as unimportant
	
By default, quips are added to the bottom of the Active stack. But we can also add quips to the Delayed stack, so they will come up sometime in the future after the current thread of conversation has ended:

	schedule (quip) as delayed
	schedule (quip) as automatic delayed
	schedule (quip) as obligatory delayed
	schedule (quip) as optional delayed
	schedule (quip) as unimportant delayed

Scheduling quips "optional delayed" is useful if we want to specify the order the NPC will bring up optional topics, rather than having the conversation engine choose randomly from quips marked "randomly-deliverable". Scheduling quips "obligatory delayed" is useful if we want to specify a set of topics that MUST be discussed before the conversation terminates.

We can also schedule any quip "topmost", so it will be pushed to the top of the stack instead of added to the bottom. This is useful if we want a quip to come up sooner rather than later:

	schedule (quip) topmost
	schedule (quip) topmost as automatic
	schedule (quip) topmost as obligatory
	schedule (quip) topmost as optional
	schedule (quip) topmost as unimportant

	schedule (quip) topmost as delayed
	schedule (quip) topmost as automatic delayed
	schedule (quip) topmost as obligatory delayed
	schedule (quip) topmost as optional delayed
	schedule (quip) topmost as unimportant delayed
	
It's also possible to schedule a quip "conditionally", which only schedules it if it has not been said before (see Said and Unsaid Quips, below):

	conditionally schedule (quip)
	conditionally schedule (quip) as optional delayed
	conditionally schedule (quip) topmost as obligatory
	conditionally schedule (quip) topmost as optional delayed
	(and so forth)
	
One detail: quips can only appear once in a given stack at a given time. If we try to schedule a quip that's already on the specified stack, the new instance will replace the old instance. This is usually what we want, but if we want a quip to come up repeatedly, we can re-schedule it from its "listing" rule:

	quip-geology is a quip. Listing quip-geology:
		say "Dr. Vandenburg continues lecturing about geology.";
		schedule quip-geology as optional.

Section: Restricting Quip Scope

Every quip has a scope, or a defined range of situations in which it can be used. By default, quips can be used in all situations, but we can also restrict their use by defining specific rules.

The first (and most basic) kind of scope is "deliverability". If a quip is not deliverable, Stacked Conversation will simply refuse to deliver it and will use the default response quip for that NPC instead. The simplest way to define deliverability is with "requires" relations:

	quip-cheese is a quip. It requires the quip quip-milk.
	quip-cheese is a quip. It requires the scene cooking.
	quip-cheese is a quip. It requires the past scene cooking.
	quip-cheese is a quip. It requires the fact fact-allergy.
	
"Requires the quip (quip)" means the quip is only deliverable when the specified quip has been said (see Said and Unsaid Quips, below). "Requires the scene (scene)" means the quip is only deliverable during the specified scene. "Requires the past scene (scene)" means the quip is only deliverable once the specified scene has occurred. "Requires the fact (fact)" means the quip is only deliverable if the interlocutor knows the specified fact (see Factual Information, below).

(NOTE: Due to the way Inform handles the word "it", using the phrasing "It requires..." is only safe immediately after the quip definition. Elsewhere, it can cause strange behavior. The long-form phrasing "quip-cheese requires..." should always work.)

For more flexibility, we can override these rules with manual deliverability definitions - for example:

	Definition: quip-burnt-toast is deliverable if the toaster is in the attic.
	
Operating concurrently is a system called "legal topics", which provides a convenient way to temporarily include or exclude whole ranges of quips based on their topic category. Every NPC has a list called "legal topics", and if the relevant NPC's legal topics list is not empty, Stacked Conversation will only allow quips whose topic category is in the list. For example, we might want an event to temporarily restrict the available topics:

	At the time when the clock stops:
		truncate the legal topics of Bob to 0 entries;
		add {clock, Agatha, gears} to the legal topics of Bob.
		
Now, Bob will only respond to quips with the topic category "clock", "Agatha", or "gears", at least until we change the contents of the legal topics list again. (If the clock stopping is a critical situation, we may not want to allow the player the option of randomly switching the topic to, say, penguins.) Note that restricting legal topics also restricts topicless quips -- if we want to allow them, we must add the topic category "nothing" to the list.

The final kind of scope is "relevance", which is one of the criteria used when selecting random topics to continue a conversation. By default, a quip's relevance mirrors its deliverability (if it is deliverable, it is relevant, and vice versa) but we can also override this with a custom definition:

	Definition: quip-burnt-toast is deliverable if the toaster is in the attic.
	Definition: quip-burnt-toast is relevant if the toast is carried by Bob.

Now, the player can bring up quip-burnt-toast any time the toaster is in the attic, but Bob will only bring up quip-burnt-toast of his own initiative if he is actually carrying the toast.

Section: Said and Unsaid Quips

Quips can be either Said or Unsaid. By default, all quips start as Unsaid; delivering a quip marks it as Said.

For the most part, Stacked Conversation does not care whether a quip is Said or Unsaid. It only becomes important when selecting random topics to continue a conversation (when the selection routine will ignore Said quips), and when disambiguating several possible options (when the disambiguation routine will prioritize Unsaid quips). However, we can use the Said/Unsaid attribute to provide logic for repeated quips -- for example:

	quip-toffee is a quip. "[if quip-toffee is unsaid]'Oh, I do love toffee!' exclaims Bob.[otherwise]You recall Bob saying he liked toffee.[end if]".

(In this specific case, we could accomplish a similar effect with "one of" switches, if we do not expect the quip to ever become Unsaid again:)

	quip-toffee is a quip. "[one of]'Oh, I do love toffee!' exclaims Bob.[or]You recall Bob saying he liked toffee.[stopping]".

Additionally, we can use the Conditional scheduling commands to schedule quips only if they are Unsaid (see Scheduling Quips, above). This allows us to define multiple ways of bringing up the same conversation topic without worrying about the NPC repeating itself:

	Quip-toffee is a quip. Listing quip-toffee:
		say "'Oh, I do love toffee!' exclaims Bob.";
		conditionally schedule quip-coffee-with-toffee as optional.
		
	Quip-coffee is a quip. Listing quip-coffee:
		say "'Coffee is great,' says Bob.";
		conditionally schedule quip-coffee-with-toffee as optional.

	Quip-coffee-with-toffee is a quip. Listing quip-coffee-with-toffee:
		say "Bob muses. 'You know what's great? Coffee with toffee. Mmm.'".

Likewise, we can conditionally deliver quips, so they will only be delivered if they are Unsaid:

	Instead of telling Bob about the toffee:
		say "Toffee! Food of the gods.";
		conditionally deliver quip-toffee.

Section: Querying the Status of a Conversation

There are a number of variables that store details about the status of a conversation. We've already seen some of them (the various quip attributes like Said, Unsaid, Optional, Obligatory, etc.). Other useful variables:

"The interlocutor" is the current NPC with whom the player is conversing. If the player is not conversing with anyone, "the interlocutor" will be set to "nothing":

	every turn:
		if the interlocutor is Bob, say "(You continue your conversation with Bob.)".
		
"Conversing" is a truth state that is set to True when the player is in a conversation and False when the player is not:

	every turn:
		if conversing is false, say "You really ought to talk to someone."
		
"Conversed-this-turn" is a truth state that is set to True when a quip was delivered in the current turn and False otherwise. Among other things, this allows us to define actions that only happen when someone is speaking (or someone isn't speaking):

	every turn:
		if conversed-this-turn is false, say "There is an awkward silence."

"Actively conversing" is a definitional test to see if the player's command is a conversation action. (This is distinct from "conversed-this-turn", because conversation actions don't necessarily trigger quips, and quips aren't necessarily triggered by conversation actions.) Note that this is a definitional test, not a truth state, so it doesn't hold a value of "true" or "false" -- we just use it by itself:

	every turn:
		if actively conversing, say "You feel slightly shocked at having overcome your social anxiety."
		
"Responding to a query" is another definitional test, to see if the current process (e.g. listing a quip) was triggered by a conversation action. This is most useful when writing quips that can either be brought up by the player or come up by themselves:

	quip-bassoon is a quip. "[if responding to a query]'Where'd you get the bassoon?' you ask.[paragraph break]'Oh, I bought it this morning at the gas station,' Bob says. 'Some guy in a truck.'[otherwise]'Hey, did you see my new bassoon?' Bob says. 'I bought it this morning at the gas station. Some guy in a truck.'".
	
(Internally, this is testing if (a) the player typed a conversation command, and (b) this is the first quip delivered this turn. The latter condition can also be accessed directly through the truth state "on-first-quip". Note, however, that "on-first-quip" doesn't get unset until after the first quip completes, so if the "listing" rule for the first quip directly delivers other quips, "on-first-quip" -- and thus "responding to a query" -- will still be set. This is rarely an issue, however.)

"The last quip" stores the last quip that was spoken, or "nothing" if no conversation has happened yet:

	quip-cabbage is a quip. "[if the last quip is quip-ketchup]Bob looks confused. [end if]'You mean the cabbages?'".

"The conversation topic of the interlocutor" stores the current topic of conversation, or "nothing" if no topic has yet been set. (Be careful, however! If the player is not in a conversation, "the interlocutor" will be set to "nothing" and trying to retrieve this value may have unexpected results. We must make sure that the player is in a conversation before using it.)

	every turn:
		if conversing:
			if the conversation topic of the interlocutor is nothing, say "OK, enough small talk. You must find a weightier topic...".

Section: Topic Transition Phrases

To make conversations sound more natural, we may want characters to acknowledge when they change subjects. This could be accomplished by testing the "last quip" variable in the listing routines for certain quips, as above, but Stacked Conversation provides an easier way -- the "transitioning from (topic category) to (topic category)" action:

	Instead of transitioning from Aunt Agatha to clocks:
		say "'That reminds me, I never did tell you about Agatha's clock,' Bob says.".
		
We can also use the more generic "transitioning to (topic category)" action, which doesn't care what the previous topic was:

	Instead of transitioning to clocks:
		say "'Ah, I should mention the clocks,' Bob says.".

As usual, when multiple rules apply, the most specific one takes precedence. For example, if we used both rules above, the first statement would trigger when transitioning specifically from Aunt Agatha to clocks, and the second statement would trigger when transitioning from any other topic to clocks.

Note that topic transitions are not restricted to specific NPCs by default. If the player can discuss the same topics with multiple NPCs, we need to specify additional conditions:

	Instead of transitioning to clocks when the interlocutor is Bob:
		say "'Ah, I should mention the clocks,' Bob says.".

	Instead of transitioning to clocks when the interlocutor is Juanita:
		say "Juanita brightens up. 'That reminds me...'".
		
Also note that, because of how Inform interprets actions that use the noun "nothing", we cannot say:

	Instead of transitioning from nothing to clocks...
	
Rather, we must use the generic "transitioning to" action ("Instead of transitioning to clocks..."). If we need to verify that we are transitioning from "nothing", we can just test "if the conversation topic of the interlocutor is nothing" (since the conversation topic is not actually changed until after the transition action).

Chapter: Advanced Conversations

Section: Factual Information

Facts let us track what information each character knows (for example, to alter how an NPC talks about something, or to use as part of a quip scope definition). Facts are abstract objects that every person in the game either "knows" or "does not know":

	fact-bob-likes-tea is a fact.
	Laurie knows fact-bob-likes-tea.
	
We can make facts known in several ways. The most simplistic is to do it person-by-person:

	quip-talk-about-tea is a quip. Listing quip-talk-about-tea:
		say "'Oh, I love tea!' says Bob.";
		now the player knows fact-bob-likes-tea.
		
However, since Bob is just announcing this fact out loud, we would expect every person within earshot to now know it. We can use the "publicly announce" phrase to make a fact known to everyone who can see the player:

	After opening the middle drawer:
		publicly announce fact-diary-in-drawer.
		
When printing text, we can use a shorthand for "publicly announce" -- just include the fact in brackets:

	quip-talk-about-tea is a quip. "'Oh, I love tea!' says Bob[fact-bob-likes-tea].".
		
The converse of "publicly announce" is "forget", which makes a fact unknown to everyone who can see the player. This is useful if a fact is proven wrong (or if our game features spontaneous amnesia). As before, we can use the phrase directly, or include it in printed text:

	After waving the magic wand:
		forget fact-bob-likes-tea.

	quip-talk-about-tea is a quip. Listing quip-talk-about-tea:
		say "'Ugh, I hate tea,' says Bob[forget fact-bob-likes-tea].".

We can also "globally announce" or "globally forget" facts, to make them known or unknown to every person in the game simultaneously:

	After opening the middle drawer:
		globally announce fact-diary-in-drawer;
		globally forget fact-diary-is-a-myth.

Section: Greetings, Farewells, Default Responses, and Idling

Stacked Conversation provides two actions for greeting and taking leave -- named, most unintuitively, "greeting" and "taking leave of". The default responses aren't very interesting ("You greet Bob", etc.), so we may want to provide our own by defining an NPC's "greeting quip" and "leavetaking quip":

	quip-hello is a quip. "'Bob!' you call out. 'What's up, old chap?'".
	The greeting quip of Bob is quip-hello.

	quip-bye is a quip. "'Lovely talking with you,' you say. 'Farewell!'".
	The leavetaking quip of Bob is quip-bye.
		
These actions are used for explicitly greeting or taking leave of someone (e.g. with the GREET command). For implicit greetings and leavetakings (e.g. when we terminate a conversation by walking to another room), there is a separate set of actions - "implicitly greeting" and "implicitly taking leave of". By default, these actions are silent, but as above, we can specify a response by defining an NPC's "implicit greeting quip" and "implicit leavetaking quip":

	quip-wave is a quip. "You wave Bob over.".
	The implicit greeting quip of Bob is quip-wave.

	quip-cheerio is a quip. "'Well, cheerio,' you say to Bob.".
	The implicit leavetaking quip of Bob is quip-cheerio.

Each NPC also has a default response quip that is delivered if a more specific action is not specified. By default, this is set to a quip called the "global default response quip", which displays "(Person) does not react." This is boring, so we can specify custom default responses:

	Quip-custom-default is a quip. "Bob looks confused. 'Eh, what's that?'".
		
	The default response quip of Bob is quip-custom-default.
	
We may want characters to "idle" -- for example, an NPC might scratch its nose whenever it doesn't talk. Since idling actions may continue even outside of conversation, Stacked Conversation does not explicitly include a feature for this. However, idling routines are easy to implement with a little context-sensitive logic:

	Every turn when the player can see Bob:
		if conversed-this-turn is false, say "[one of]Bob scratches his head.[or]Bob stares blankly at the wall.[or]Bob sighs.[at random]".

Section: Asking and Answering Questions

It is often useful to restrict what the player can do, especially if we want an NPC to ask the player a question. There is no dramatic tension in interactions like:

	Bob levels the gun at your head. "Say it," he snarls. "Say you didn't do it!"
	
	> TAKE LANTERN
	Taken.
	
	> SING
	Your singing is abominable.
	
To prevent this, we can restrict player actions with the phrase "restrict conversation with (quip)", after which the game will refuse all player actions by displaying the specified quip. We can then enable specific actions with the phrase "permit (stored action)". When we want to remove these restrictions, we just use the phrase "unrestrict conversation". For example:

	quip-uncomfortable is a quip. "You feel awkward not answering Bob's question.".
	
	quip-pick-an-aunt is a quip. Listing quip-pick-an-aunt:
		say "'Which aunt did you want to tell me about?' Bob asks.";
		restrict conversation with quip-uncomfortable;
		permit the action of telling Bob about the object Aunt Agatha;
		permit the action of telling Bob about the object Aunt Martha.
	Instead of interacting with Bob about the object the aunts, deliver quip-pick-an-aunt.
	
	quip-agatha is a quip. Listing quip-agatha:
		say "You mumble something about Aunt Agatha.";
		unrestrict conversation.
	Instead of telling Bob about the object Aunt Agatha, deliver quip-agatha.

	quip-martha is a quip. Listing quip-martha:
		say "You leap on top of the table. 'Martha is in England!' you proclaim, with great vigor.";
		unrestrict conversation.
	Instead of telling Bob about the object Aunt Martha, deliver quip-martha.
	
Assuming we have the appropriate objects defined, this might play out like:

	> TELL BOB ABOUT AUNTS
	'Which aunt did you want to tell me about?' Bob asks.
	
	> X LANTERN
	You feel awkward not answering Bob's question.
	
	> TELL BOB ABOUT AGATHA
	You mumble something about Aunt Agatha.

One limitation of this method is that Inform requires stored actions to be complete: that is, we can permit specific actions like "taking the lantern", but not general classes of action like "taking something". This is usually fine if we only need to permit specific quip triggers, but can pose a problem in other scenarios. To combat this, Stacked Conversation provides special phrases to cover the most common cases:

	permit examining;
	permit movement;
	permit taking;
	permit dropping;
	permit leavetaking;
	permit movement but not leavetaking;
	permit non-conversation actions;
	permit conversation actions;
	
"Permit movement but not leavetaking" is a special case that requires some explanation. The normal "permit movement" phrase automatically permits leavetaking as well, because movement generally terminates the conversation. This is not always true, however; we may encounter scenarios in which movement makes sense but leavetaking doesn't, like a robot sidekick that follows the player everywhere. (See Mobile Characters, below.) In this case, "permit movement but not leavetaking" might be more appropriate.

"Permit non-conversation actions" removes almost all restrictions: only conversation-related actions will be restricted. (This includes actions that would implicitly terminate the conversation, so if we wish to let the player walk away without answering the question, we must use "permit leavetaking" as well.)

"Permit conversation actions" is not normally useful, since in most cases restricting conversation is the whole point, but it is provided in case we want to use the restriction routines in other contexts.

Note that terminating a conversation with an NPC will automatically remove any restrictions. If we want the conversation to be restricted again when the player resumes conversation, we need to add the appropriate restriction code to the greeting procedures.

Because yes/no questions are so common, Stacked Conversation provides a shorthand way to restrict player responses to yes/no:

	restrict conversation to yes-no with (quip);
	
This is equivalent to restricting conversation normally and then permitting "saying yes to (the interlocutor)", "saying no to (the interlocutor)", "implicitly saying yes", and "implicitly saying no".

There is an alternate way of establishing limited responses to questions -- we can use the "legal topics" system described in Restricting Quip Scope (above) to only permit certain responses, and temporarily change the default response quip for the NPC to emulate the restriction quip. However, the restrictions system described here is generally clearer and more flexible.

Section: Matching Keywords

When writing manual "instead..." rules for complex queries, like "ask whether Bob's grandmother is a turkish ninja", it is often useful to match keywords instead of complete phrases (so we don't have to worry about understanding fifteen different variations of each phrase). We could use complex features like regular expressions, but Stacked Conversation provides several built-in decision phrases for keyword matching:

	(text) matches one of (list of keywords)...
	(text) matches all of (list of keywords)...
	(text) matches one of the keywords (list of keywords)...
	(text) matches all of the keywords (list of keywords)...
	
These phrases return true if keywords from the list can be found in the text. The first two phrases match keywords anywhere in the text; the last two only match complete words (which is usually what we want). An example of an Instead rule using keyword matching:

	Instead of asking Bob about a topic when the topic understood matches one of the keywords { "turkish", "ninja" }, deliver quip-grannie-is-a-ninja.
	
We could also write more complicated conditions with multiple matches -- for example, if we needed to recognize a query that mentions both ninjas and grandmothers:

	Instead of asking Bob about a topic when the topic understood matches one of the keywords { "turkish", "ninja" } and the topic understood matches one of the keywords { "grandma", "grandmother", "granny", "grannie" }, deliver quip-grannie-is-a-ninja.

Note that matching "the keywords" only considers individual words, not phrases (so we can't have a multi-word list entry like "turkish ninja").

One more matching phrase is available:

	the number of words in (text) that match the keywords (list of keywords)...
	
This is useful mainly in disambiguation routines that try to find the best match out of several options (which is, in fact, what Stacked Conversation uses it for internally).

Section: Queries With Multiple Possibilities

We may occasionally want the same query to behave differently in different contexts -- e.g., the command "ASK ABOUT CALICO" might have a different meaning when the player is in a cloth shop versus when they are carrying a calico blanket. There are several ways we can vary responses by context, some of which are more automatic than others.

For simple changes, we can just define a quip that operates differently in different contexts. For example:

	quip-calico is a quip. "[if driving the train is happening]Bob grins. 'Yep, just throw it out the window!'[otherwise]'Remind me to pick up the calico blanket,' Bob says.[end if]".
		
However, this solution isn't ideal for quips that fall in the middle of a long thread, quips we want to schedule conditionally in some contexts, etc. A more flexible solution is to provide several quips, and select the right one in the original query action. For example:

	Instead of interacting with Bob about the object the calico blanket:
		if driving the train is happening:
			deliver quip-calico-train;
		otherwise if the calico blanket is carried by Bob:
			deliver quip-calico-carried;
		otherwise:
			deliver quip-calico-generic.
			
If we are making significant use of deliverability restrictions (see Restricting Quip Scope, above), Stacked Conversation provides some shortcuts to help us select the most appropriate quip from a set. The first is "the first available quip in {list of quips}", which selects the first deliverable quip from the specified list, prioritizing Unsaid quips over Said quips. (If none of the quips in the list are available, it just selects the default response quip for the interlocutor.) For example:

	deliver the first available quip in {quip-calico-train, quip-calico-carried, quip-calico-generic};
	
This is useful when quips have a definite order of priority -- that is, certain quips will always be favored over other quips, even if more than one is available. Sometimes, however, we have multiple equally valid options. In this case, we can use the phrase "disambiguate the quips {list of quips}". If there is only one deliverable quip, it will be delivered; otherwise, Stacked Conversation will ask the player to choose from a list of options. For example:

	Instead of interacting with Bob about the object tea, disambiguate the quips {quip-make-tea, quip-tea-is-imported, quip-last-tea}.
	
(This is what happens internally during automatic keyword-matching, so in practice, we can build very elaborate conversations using only quip keywords and deliverabilty restrictions. Also note that -- as an "instead" rule -- this occurs during a normal turn, unlike Inform's built-in object disambiguation, which occurs before the command is executed. This means that a turn will elapse even if disambiguation fails.)
	
Note that Stacked Conversation uses each quip's "printed name" attribute to display the list of possibilities and interpret the player's response, so if the applicable quips do not already have the name we want to appear, we need to declare it:

	quip-tea-is-imported is a quip. The printed name is "whether his tea is imported".

(Of course, we'll probably want separate ways to trigger each of these quips on their own, so that the player can type commands like "ASK BOB WHETHER HIS TEA IS IMPORTED". This can be accomplished in the usual way, e.g. with keywords, or by creating a subject called "whether Bob's tea is imported" with various wording alternatives and triggering a quip when the player asks about it.)

Section: Mobile Characters

By default, moving between locations terminates the current conversation. This is usually what we want, but what if the NPC follows the player around, or the player can communicate from a distance? We can disable this rule by declaring that a character is "conversationally mobile":

	Bob is conversationally mobile.
	
Of course, we need to create some way to communicate with the NPC after moving, or else this is kind of pointless -- the player will still technically be in a conversation, but won't be able to interact with the NPC because it's in a different room. Creating an NPC that follows the player around is straightforward:

	After going: now Bob is in the location of the player; continue the action.

Letting the player communicate with an NPC from a distance is slightly more complicated:

	After deciding the scope of the player: place Bob in scope.
	A rule for reaching inside a room: if the person reaching is the player and the current action involves Bob, allow access.

Section: Conversing With Multiple Characters

Stacked Conversation assumes the player is only conversing with one NPC at a time. Sometimes, however, we want multiple NPCs to interact as a group, with dialogue interwoven together -- for example, if a group of NPCs are planning a mission or chatting about their lives together.

Stacked Conversation solves this by letting us define a dummy person called a "conversation mastermind" and redirect individual queries to it by setting the "group conversation stand-in" property of each NPC in the group. For example:

	The inaccessible storehouse is a room.
	those assembled are a conversation mastermind in the inaccessible storehouse.

	When the group dinner begins:
		now the group conversation stand-in of Bob is those assembled;
		now the group conversation stand-in of Laurie is those assembled;
		now the group conversation stand-in of Joan is those assembled.

Now, whenever the player interacts with Bob, Laurie, or Joan, their query will instead be redirected to the defined conversation mastermind, who handles them like an individual NPC. (In this example the conversation mastermind has been named "those assembled" to create the illusion of referring to all the NPCs collectively -- "You greet those assembled.", etc.) We can now write quips that represent the NPCs conversing together, e.g.:

	quip-tofu is a quip. "Laurie looks disgusted. 'I really hate tofu,' she says. 'It has this rubbery texture that just... bleh.'[paragraph break]'Really?' Bob says. 'It's not supposed to. How do you cook it?'".
	
To remove NPCs from a group conversation, just reset their "group conversation stand-in" to "nothing".

Note that the conversation mastermind must be placed in a physical room, or Inform's scope-resolution will fail with the message "they aren't available." However, placing it in a room the player can access may cause confusion, so it's better to place it in an arbitrary unconnected room, as in the example above (which creates a room called "the inaccessible storehouse" to hold the mastermind).

Section: Character Personality

Each NPC has several variables that control their conversation style. They are defined as "1-in-X" values: i.e., a value of 1 means the action takes place 100% of the time (1 in 1), a value of 2 means the action takes place 50% of the time (1 in 2), a value of 10 means the action takes place 10% of the time (1 in 10), etc. For example:

	The quip talkativeness of Bob is 5.

"Quip talkativeness" is the probability of delivering optional quips without player prompting. The default value is 2, or a 50% probability each turn. Low values create a talkative character; high values create a more reserved character.

"Quip assertiveness" is the probability of delivering another quip directly after the previous one (essentially making Optional and Obligatory quips occasionally act like Automatic quips). The default value is 5, or a 20% probability each quip. Low values create an assertive character who frequently adds details unprompted; high values create a slower character who plays conversations out at a regular pace. (Aside from personality, this option is also useful to vary the pacing of conversations, especially if most quips are similar in length.)
	
"Topic talkativeness" is the probability of bringing up a new topic of conversation when the NPC runs out of quips on its Active stack. The default value is 3, or a 33% probability each turn. Low values create a rambling character who switches topics frequently and likes to lead the conversation; high values create a more laid-back character who prefers you to lead.

Section: Verbless Conversation

Traditionally, all commands start with a verb: EXAMINE, ASK, TELL, etc. Stacked Conversation also understands some direct responses like YES and NO, but we can extend this further with the option:

	Use verbless parsing.
	
Now, whenever the player is in a conversation and the game doesn't understand a command, it will try interpreting it as ASK ABOUT (old command). This lets us have exchanges like:

	"Well, what do you want to hear about first, the piano or the llama?" says Bob.
	
	> THE PIANO
	"Well, it's a long story..." Bob begins.
	
Outside of a conversation, failed commands behave normally.

Chapter: Suggesting Topics of Conversation

Section: Overview

Conversation in interactive fiction is inherently limited -- authors can only write so many responses. Thus, writing an effective conversation is often more about guiding the player towards useful queries than about comprehensively implementing everything they might want to talk about. Ideally, this can be accomplished with clever quip-writing, but we may also want to give the player explicit suggestions. To this end, Stacked Conversation provides features to (a) maintain a network of suggested topics, and (b) display them in a context-appropriate manner when needed.

Each NPC has two lists of quips: the "suggested topics list" and the "suggested subject change list". The first list comprehensively stores all the suggestions the game could make when conversing with that NPC, which are then filtered by the current conversation topic to produce context-appropriate suggestions. The second list stores general suggestions unrelated to the current topic. This lets Stacked Conversation generate prompts like:

	You could discuss the hatband, whether Bob likes his hat, or current millinery trends.
	
	Or, you could change the subject to nuclear war or watchmaking.

In all cases, Stacked Conversation will only present suggestions that are Unsaid and not restricted in some way (see Restricting Quip Scope, above), so we don't have to worry about it suggesting things we can't talk about or have already discussed.

Section: Building Suggestion Lists

We can manage each NPC's lists with the phrases "suggest (a quip)", "unsuggest (a quip)", "suggest the subject change (a quip)", and "unsuggest the subject change (a quip)". By default, these modify  the current interlocutor's suggestion lists, but we can also specify a specific NPC by appending "for (someone)" if we need to. Some examples:

	suggest quip-nuclear-war.
	unsuggest quip-teapot for Bob.
	suggest the subject change quip-lava-lamps for Laurie.
	unsuggest the subject change quip-lava-lamps.

(These phrases do more than just add and remove entries, to enable some of the customizations below, so we should generally use them instead of Inform's built-in list management features.)

A point to remember: Suggestions are quips, not actions. Quips can be triggered in a number of ways, so it's possible that the quip used to generate the suggestion list won't be the actual quip triggered by inquiring about that topic. (In theory, we could even create empty quips to use as placeholder suggestions.) In practice, this rarely causes problems, but it's important to remember in case the quip logic get particularly complicated.

As with disambiguation (see Queries With Multiple Possibilities, above), Stacked Conversation uses the printed name of each quip to display the suggestions list. If the quip doesn't already have the name we want, we'll have to define it:

	quip-tea-is-imported is a quip. The printed name is "whether his tea is imported".

Section: Listing Suggestions

Suggestions can be listed in several ways. By default, Stacked Conversation will only list suggestions when the player explicitly requests them, e.g. by typing "topics", "what should I say", etc. (This is performed through the action "requesting topic suggestions".) However, we can also turn on one or more extra options to suggest topics automatically. The first is the simplest:

	Suggest-topics-after-conversing is true.
	
This displays suggestions at the end of every conversation-related action: the player inquires about a topic, the NPC responds, and the game immediately suggests further topics of inquiry. This is highly effective at guiding the player towards the topics we want, but gets repetitive and risks the "lawnmower effect", where players converse by systematically bringing up every available topic until they run out. A less invasive option is:

	Suggest-topics-after-inaction is true.
	
This displays suggestions if the player is in a conversation, but goes several turns without talking. (We can set how many turns using the topic-suggestion-delay variable; the default is 3.) The final option is more specific:

	Suggest-topics-after-additions is true.
	
This displays new suggestions at the end of the turn in which they are added (assuming the player is currently conversing with someone). For example, triggering a quip could add several new suggestions, which would then be displayed after the quip.

We can also manually call the suggestion-listing routines. To display the normal suggestion list, we can just use the phrase:

	suggest conversation topics;
	
If we want more control, we can use "compile available topic suggestions", which fills three lists: "available topic suggestions" (usable quips filtered by topic from the interlocutor's general suggestions list), "available subject change suggestions" (usable quips from the interlocutor's subject change list), and "currently related topics" (the list of legal topics used to filter the "available topic suggestions" list -- see Related Topics below). We can then manipulate the lists as we wish, or just use the special printing phrase "an or-list of..." to display them in the usual "X, Y, or Z" format:

	Instead of requesting topic suggestions:
		compile available topic suggestions;
		if the number of entries in the available topic suggestions is not 0:
			say "You could discuss [an or-list of the available topic suggestions].";
		otherwise:
			say "You can't think of anything to say.".

By default, topic-relevant suggestions and subject change suggestions are listed in two separate paragraphs, as in the example above. We can list them in one paragraph with the "list-suggestions-as-one-paragraph" option:

	List-suggestions-as-one-paragraph is true.

Section: Related Topics

As mentioned in Overview, above, suggestions on the main lists are filtered by the current conversation topic. But what if we want to offer suggestions from a variety of closely-related topics? For example, "tea time" and "the teapot" might technically be separate topics, but switching from one to the other wouldn't really be a change of subject.

To solve this, Stacked Conversation lets us define "subtopic" relationships between objects:

	Cryptids are a subject.
		Nessie is a subject. It is a subtopic of cryptids.
		Sasquatch is a subject. It is a subtopic of cryptids.
			DNA analysis is a subject. It is a subtopic of Sasquatch.

When filtering suggestions lists, Stacked Conversation will allow topics within one level of the current topic -- think "parents", "children", and "siblings" of the current topic. To apply the family metaphor to the example above: If the current topic was cryptids, Nessie and Sasquatch would be legal (because they are "child" topics of cryptids) but DNA analysis would not be legal (because it is a "grandchild" topic of cryptids). If the current topic was DNA analysis, Sasquatch would be legal (because it is a "parent" topic of DNA analysis), but Nessie and cryptids would not be legal (because they are "uncle" and "grandparent" topics, respectively). If the current topic was Sasquatch, all four topics would be legal - cryptids is a "parent", Nessie is a "sibling", and DNA analysis is a "child." Etc.

Chapter: Internals

Section: Automatic Keyword Matching

Automatic keyword matching (see Triggering Quips, above) is usually the easiest way to write a conversation. It can run slowly, however, and the need to index quip speakers can cause a startup delay. If we only intend to use manual "Instead" rules, we can disable automatic matching altogether with the option:

	Use manual quip-matching only.

Section: Z-Code vs. Glulx

Stacked Conversation works with both Z-Code and Glulx, but Glulx is recommended for stability. Some operations are fairly resource-intensive (particularly automatic quip matching), so Z-Code will quickly run out of dynamic memory as conversations grow.

Example: **** Please Pass the Manners - A quick and silly minigame featuring two conversant NPCs, one of whom you'd rather not have around...

Some notes:

We use a conversation mastermind to simplify coding for two characters; when Lady Blackholdt leaves the room, the mastermind is unlinked and we speak directly to Louis. In effect, any dialogue associated with Mastermind is only available before Lady Blackholdt leaves, and any dialogue associated with Louis is only available after.

There are other ways to do reactions besides quips, but quips set the conversed-this-turn flag, which may come in useful. Notice that, because reactions are mostly delivered "conditional", they will only appear the first time we perform each action.

	*: "Please Pass the Manners"

	Include Stacked Conversation by Daniel Gaskell.

	Chapter - Options, Backdrop, and Characters

	Suggest-topics-after-inactivity is true.
	List-suggestions-as-one-paragraph is true.
	Use verbless parsing.
	Use scoring. The maximum score is 1.

	When play begins:
		say "When you were a child in the boroughs, you dreamed of this kind of romance -- cities, lights, boat rides on the Caimh. But sometimes truth runs faster than fantasy, and sometimes dreams get it wrong. The lights were brighter, the cities bigger than anything in your dreams.[paragraph break]Louis Blackholdt. Artist. Landowner. Amateur debonair. A baron of plausible importance, although you didn't know that until nearly a year after you first met. And now, here you sit, at dinner in his family's estate. Everything is settled, and all that remains is the formal proposal.[paragraph break]Only one problem: a certain Lady Blackholdt...";
		try implicitly greeting mastermind;
		suggest the subject change quip-weather;
		suggest the subject change quip-health;
		suggest the subject change quip-relations;
		the hint timer rings in 15 turns from now.
		
	At the time when the hint timer rings: if the player can see Lady Blackholdt, say "This is going nowhere. If you want Louis to propose, you'll have to find somewhat to get Lady Blackholdt out of the room."

	The Dining Hall is a room. "Lady Blackholdt speaks a lot about 'good taste,' but the overpowering gaudiness of this dining hall makes you wonder what her definition of 'good taste' is. But right now it's hard to focus on the hall, or the food, or even Lady Blackholdt, with Louis seated next to you."

	Lady Blackholdt is a woman in the dining hall. "Lady Blackholdt sits across the table, glowering at you haughtily." The description is "The best adjective you can think of is 'stately,' but definitely one of those smaller states with warlords or Thuggee or somesuch. Lady Blackholdt has never been fond of you, and particularly not of your relationship with her son."

	Louis is a man in the dining hall. The description is "You see nothing special about Louis.[paragraph break]That's a lie, of course. Louis is the most special person you've ever met. The first time you ever saw him, it was just his arm, closing a door across the room -- and something made you run after him, trip and almost fall on top of him.[paragraph break]'Oh,' he said.[paragraph break]'Sorry,' you said.[paragraph break]'That's --' he said.[paragraph break]'Are --' you said.[paragraph break]'Louis,' he said. 'And who are you?'". He is scenery. [Because he's described in the room description.]

	A table is a supporter in the dining hall. It is scenery. The description is "An enormous mahogany affair with brass curlicues and built-in trivets. You and Louis sit together on one side[if the player can see Lady Blackholdt], Lady Blackholdt on the other[end if]."

	A glass of wine is on the table. The description is "An elegant wineglass, half-full of a refined Côtes du Rhône. It belongs to Lady Blackholdt." Understand "drink" or "cup" or "juice" or "liquid" or "beverage" or "cotes du rhone" or "cotes" or "rhone" or "côtes" or "rhône" as the glass of wine.
	Instead of doing something other than examining when the noun is the glass of wine or the second noun is the glass of wine: say "Lady Blackholdt might not take kindly to that."

	The food is on the table. The indefinite article is "some". It is edible. The description is "Braised pheasant, potatoes, something with currants. It's probably delicious, but your mind is elsewhere right now."
	Instead of eating the food:
		say "You take a few bites of your food, but you're not very hungry.";
		if the player can see Lady Blackholdt, conditionally deliver quip-react-food.
	Instead of taking the food: try eating the food.
	Does the player mean eating the food: it is likely.

	Chapter - Conversation

	Topic-marriage is a subject. Topic-weather is a subject. Topic-health is a subject.

	Section - Interactions

	The inaccessible storehouse is a room. The mastermind is a conversation mastermind in the inaccessible storehouse. The printed name is "two". It is plural-named.
	The group conversation stand-in of Louis is mastermind.
	The group conversation stand-in of Lady Blackholdt is mastermind.

	quip-mastermind-greeting is a quip. "You turn your attention back to the conversation."
	The greeting quip of mastermind is quip-mastermind-greeting.
	The implicit greeting quip of mastermind is nothing.

	quip-mastermind-leavetaking is a quip. "You don't dare ignore Lady Blackholdt, so you decide to just keep quiet instead.".
	The leavetaking quip of mastermind is quip-mastermind-leavetaking.

	quip-louis-greeting is a quip. "You turn back to Louis."
	The greeting quip of Louis is quip-louis-greeting.
	The implicit greeting quip of Louis is quip-louis-greeting.

	quip-louis-leavetaking is a quip. "You turn your attention away from Louis for a moment.".
	The leavetaking quip of Louis is quip-louis-leavetaking.

	Section - Dialogue

	[weather quips]

	quip-weather is a quip. The topic category is topic-weather. The printed name is "the weather". The speaker is mastermind. Ask words are {"weather", "storm", "storms", "stormy", "cloud", "clouds", "cloudy", "clouded"}. Listing quip-weather:
		say "[one of]'So, how about that weather?' you ask, trying to ignore the imaginary cliché scurrying across the table in the periphery of your vision. (It's small and furry.)[paragraph break]'It has been quite frightful,' Louis agrees. Lady Blackholdt clicks her tongue in disapproval, but in disapproval of [italic type]what[roman type], you're not sure.[or]You've pretty much exhausted the topic of weather.[stopping]";
		suggest quip-rain;
		schedule quip-stormy as optional.

	quip-rain is a quip. "[one of]'Do you think it will rain?' you ask.[paragraph break]'I don't know,' Louis begins, 'it was raining during the parade the other --'[paragraph break]'I know someone who could rain on [italic type]my[roman type] parade, if you know what I mean,' says Lady Blackholdt darkly.[or]You've pretty much exhausted the topic of weather.[stopping]". The topic category is topic-weather. The printed name is "whether it will rain". The speaker is mastermind. Ask words are {"rain", "raining", "rained", "precipitation"}.

	quip-stormy is a quip. "'Quite stormy lately, hasn't it been,' says Louis. There is an uncomfortable silence.". The topic category is topic-weather.

	[health quips]

	quip-health is a quip. The topic category is topic-health. The printed name is "each other's health". The speaker is mastermind. Ask words are {"health", "welfare", "well"}. Listing quip-health:
		say "[one of]'Ah,' you say. 'Have you both been quite well?'[paragraph break]'Quite,' says Lady Blackholdt. 'Although with this nasty draft, I shouldn't be surprised if we all come down with a frightful cold tomorrow.'[or]The last time you asked, Lady Blackholdt complained about the draft.[stopping]";
		suggest quip-cold;
		schedule quip-inlaws as optional.

	quip-cold is a quip. "[one of][if the last quip is quip-health]'Yes, the draft is a little chilling,' you say. [end if]'I hope we will all stay well.'[paragraph break]'Well, I hope [italic type]I[roman type] stay well,' Lady Blackholdt says. 'And Louis, I suppose.' You glance over at Louis, who seems to be biting his tongue.[or]Lady Blackholdt didn't seem too concerned about the prospect of you getting sick.[stopping]". The topic category is topic-health. The printed name is "colds". The speaker is mastermind. Ask words are {"cold", "colds", "illness", "illnesses", "ill", "sick", "draft"}.

	[relations quips]

	quip-relations is a quip. The topic category is topic-relations. The printed name is "relations". The speaker is mastermind. Ask words are {"relations", "relative", "relatives"}.  Listing quip-relations:
		say "[one of]'How are the relations?' you ask, hoping for a lighter subject.[paragraph break]'Oh, well enough,' interjects Lady Blackholdt before you finish speaking. 'All making great advances in society, especially my son, although [italic type]that may change[roman type].'[or]You feel like further discussion of relatives would just circle back to Lady Blackholdt's disapproval.[stopping]";
		schedule quip-inlaws as optional.

	quip-inlaws is a quip. "'Have you heard from Percy lately?' Louis says, trying to change the subject. 'Last I heard he was in Herringshire.'[paragraph break]'Yes, he's engaged to that duchess now.' Lady Blackholdt looks pointedly at you, then back to Louis. 'A good marriage, if I do say so. She owns half the borough.'". The topic category is topic-relations.

	[leaving]

	quip-leave is a quip. "[one of]'Well, it's been a pleasant conversation,' you say. 'Perhaps Louis and I should retire for a walk around the grounds.'[paragraph break]'I won't have you spending time with... [italic type]that[roman type] creature,' Lady Blackholdt says with disgust. Louis looks at you apologetically.[or]You'd rather not bring up leaving again, to be honest.[stopping]". The speaker is mastermind. Ask words are {"leave", "leaving", "alone", "exit", "retire", "walk"}.

	Section - Reactions

	quip-lady-random is a quip. "[one of]Lady Blackholdt delicately minces her food into even smaller pieces, never breaking eye contact with you.[or]Lady Blackholdt clears her throat.[or]Lady Blackholdt gives you a cold glance.[or]Lady Blackholdt readjusts her napkin pointedly.[or]Lady Blackholdt grimaces politely.[or]Lady Blackholdt's disdain intensifies.[or]Lady Blackholdt frowns, and for a split second, her expression flickers from 'regal disdain' to 'undisguised loathing'.[or]Louis touches your hand reassuringly.[or]You feel Louis give your hand a squeeze under the table.[at random]".

	Every turn when the player can see Lady Blackholdt:
		if conversed-this-turn is false and a random chance of 2 in 3 succeeds, deliver quip-lady-random.
		
	quip-react-glass is a quip. "Lady Blackholdt sees you looking at her wine and snorts disapprovingly. 'Probably wouldn't know a Viognier from a Chardonnay if it hit her between the eyes...'". 
	After examining the glass of wine when the player can see Lady Blackholdt: conditionally deliver quip-react-glass.

	quip-react-x-lady is a quip. "Lady Blackholdt sees you staring and raps sharply on the table. 'What are [italic type]you[roman type] looking at?'".
	After examining Lady Blackholdt: conditionally deliver quip-react-x-lady.

	quip-react-x-louis is a quip. "Lady Blackholdt clears her throat rather loudly, and you reluctantly tear your eyes away from Louis.".
	After examining Louis when the player can see Lady Blackholdt: conditionally deliver quip-react-x-louis.

	quip-react-food is a quip. "Lady Blackholdt watches you eat with a calculated stare, like a witch trying to decide whether to fatten you up before she eats you.".
	[deliver rule defined above]

	quip-react-inventory is a quip. "'What's she looking at?' you hear Lady Blackholdt mutter.".
	After taking inventory when the player can see Lady Blackholdt: conditionally deliver quip-react-inventory.

	Chapter - Game Mechanics

	Section - Removing Lady Blackholdt

	Understand "knock [something]" or "knock over [something]" or "bump [something]" or "spill [something]" as pushing.

	Instead of pushing the glass, spill the wine.
	Instead of attacking the glass, spill the wine.

	To spill the wine:
		say "You casually sweep your hand across the table and 'accidentally' knock over Lady Blackholdt's glass of wine. She leaps back, wine pouring off her gown.[paragraph break]'Why! -- you! --' she sputters. Her expression changes quickly from rage to horror to rage again, before settling back into a well-practiced disdain. 'Well,' she says, drawing out the vowel, 'I think I know what kind of company [italic type]I'll[roman type] not be keeping any more tonight.' She flounces out of the room, leaving you and Louis alone.";
		increment the score;
		remove Lady Blackholdt from play;
		remove the wine glass from play;
		now the group conversation stand-in of Louis is nothing;
		try implicitly greeting Louis;
		suggest quip-marriage;
		schedule quip-marriage as obligatory delayed.

	Section - Proposal

	flag-asking-about-marriage is initially false.

	quip-marriage-restrict is a quip. "You flush, the answer unexpectedly catching on your tongue..."

	quip-marriage is a quip. The topic category is topic-marriage. The printed name is "marriage". The speaker is Louis. Ask words are {"marriage", "marry", "wedding", "propose", "proposal", "bride", "groom", "wife", "husband"}. Listing quip-marriage:
		say "[if responding to a query]You open your mouth to speak, but Louis stops you. 'Wait,' he says softly, staring into your eyes. 'Let me do this properly.'[paragraph break][otherwise]There is a pause. Louis meets your eyes, and suddenly your heart skips a beat. You can see it, through his eyes, something deep and beautiful and ancient, ready to ignite.[paragraph break][end if]And he's on one knee, holding something in his hand.[paragraph break]'Will you marry me?'";
		now flag-asking-about-marriage is true;
		restrict conversation to yes-no with quip-marriage-restrict.
		
	Instead of interacting with mastermind about something when the topic understood matches one of the keywords {"marriage", "marry", "wedding", "propose", "proposal", "bride", "groom", "husband"}, say "Goodness, that's not something to bring up around Lady Blackholdt! You'll have to get her to leave somehow.".

	Instead of saying yes to Louis when flag-asking-about-marriage is true:
		say "Maybe you say yes. Maybe you never quite get it out. All you know is that you can feel his arms around you, and your heart is in your throat, and someone is crying, and your world will never be the same...";
		end the story finally saying "You have found true love".
		
	Instead of saying no to Louis when flag-asking-about-marriage is true:
		say "You look at Louis sadly.[paragraph break]'No,' you say at last. 'I don't think this is a good idea. I'm sorry.'";
		end the story saying "You have made Lady Blackholdt slightly less peeved".

	Chapter - Testing

	Test me with "x lady blackholdt / x louis / ask louis about marriage / what can i say / ask about the weather / x table / x food / eat food / talk about the possibility of rain / z / z / talk about storms / discuss health / x glass / ask about her relations / knock over glass / ask louis about marriage / yes".

	Test extreme with "nice weather we're having / how is your health? / don't worry about the draft / how about i marry your son / spill drink / passionately implore louis to make me his wife / yes".