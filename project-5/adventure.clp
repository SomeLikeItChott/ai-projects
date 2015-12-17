;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;; Set up templates
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(deftemplate objct 
	(slot name) (slot location) (slot edible?) (slot isa) (slot used))
(deftemplate person 
	(slot location) (slot Credits) (slot Salary) (slot Moves) (slot Ate) (slot Slept))
(deftemplate place 
	(slot name) (slot north) (slot south) (slot east) (slot west) (slot info))
(deftemplate door 
	(slot name) (slot from) (slot to) (slot status) (slot direction))
(deftemplate mode (slot status))
;(deftemplate input (slot command) (slot argument))

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;; Set up templates
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;; YOU ARE ENCOURAGED TO ADD/ALTER PLACES AND THEIR "info" DESCRIPTIONS 
(deffacts TU
	(mode (status start))
	(place (name Graduation) (south ACAC)
	 (info "Your cap falls off now and then, your gown does'nt fit you but your frozen smile shows it all!"))
	(place (name Summer_Job) (east ACAC) (info "Is'nt this supposed to be a summer camp?"))
	(place (name 4253) (east Keplinger) (info "Most fun I have ever had in a course!!"))
	(place (name 1043) (east McFarlin) (info "You got to start somewhere."))
	(place (name Dorm_Room) (east McClure) (info "All work and no sleep ... "))
	(place (name Cafetaria) (east Skelly) (info "Lots to eat; mind your cholesterol"))
	(place (name Orientation) (north Skelly) (info "Welcome to wonderland!"))
	(place (name Skelly) (north McClure) (south Orientation) (east Kendall) 
	 (west Cafetaria) (info "Go Blue"))
	(place (name McClure) (north McFarlin) (south Skelly) (east Registration) (west Dorm_Room)
	 (info "Empty your pockets here.  Right now"))
	(place (name McFarlin) (north Keplinger) (south McClure) (east 2003) (west 1043)
	 (info "A quiet place to ..."))
	(place (name Keplinger) (north ACAC) (south McFarlin) (east 3123) (west 4253)
	 (info "Home, sweet home"))
	(place (name ACAC) (north Graduation) (south Keplinger) (east Job_Interview) 
	 (west Summer_Job) (info "Food and fun, for everyone"))
	(place (name Job_Interview) (west ACAC) (info "Gimme that, gimme that"))
	(place (name 3123) (west Keplinger) (info "Another day, another course"))
	(place (name 2003) (west McFarlin) (info "Now you are coding"))
	(place (name Registration) (west McClure) (info "Enlist and serve"))
	(place (name Kendall) (west Skelly) (info "If you can act, sing, dance, ... the stage awaits"))
	(objct (name pizza) (location Cafetaria) (isa food))
	(objct (name salad) (location Cafetaria) (isa food))
	(objct (name map) (location Orientation) (isa paper))
	(objct (name schedule) (location Registration) (isa paper))
	(objct (name diploma) (location Graduation) (isa paper))
	(objct (name food) (edible? yes) (isa Object))
	(objct (name paper) (edible? no) (isa Object))
	(objct (name Object))
	(door (name sum_job) (from ACAC) (direction west) (status closed))
	(door (name job_int) (from ACAC) (direction east) (status closed))
	(door (name grad) (from ACAC) (direction north) (status closed))
	(person (location Skelly) (Credits 0) (Salary 0) (Moves 0) (Ate 0) (Slept 0)))

;; IN THE FOLLOWING I HAVE PROVIDED THE SKELETONS FOR SOME, BUT NOT ALL, OF THE 
;; PRODUCTIONS THAT YOU NEED TO WRITE FOR THIS GAME
;; NOTE: THESE SKELETONS REPRESENT HOW I IMPLEMENTED THIS GAME.  YOU ARE NOT 
;; REQUIRED TO FOLLOW THIS SKELETON.

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;  Production that detects a starting position and performs necessary makes to set up
;; the environment.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule start
	 ?mode <- (mode (status start))
	 =>
	 (modify ?mode (status run))
	 (printout t crlf "***************************")
	 (printout t crlf "*                         *")
	 (printout t crlf "* College:  The Adventure *")
	 (printout t crlf "*         By              *")
	 (printout t crlf "*      Sandip Sen         *")
	 (printout t crlf "***************************" crlf))

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;  Prompts the player for next input and reads it in
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule Read
	 ?mode <- (mode (status run))
	 =>
	 (modify ?mode (status run))
	 (printout t crlf crlf "*** What next?  ")
	 (assert (input (explode$ (readline)))))

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;  Response to an invalid command
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule Dont-Understand
	 ?input <- (input $?x)
	 =>
	 (retract ?input)
	 (printout t crlf "Invalid command"))

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;; Allows you to stop and restart very easy -- just type run again.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule quit
 ?input <- (input  stop|quit|exit|bye|halt)
	=>
 (retract ?input)
 (halt))

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;; Providing help to the player
;; YOU ARE ENCOURAGED TO ADD OTHER SYNONYMS FOR COMMANDS AND HANDLE THEM APPROPRIATELY
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule help
	?input <- (input help|guide|idontknowwhatimdoing)
	=>
	(printout t crlf "Type north, south, east, west to move around")
	(printout t crlf "You can use other commands such as sleep, get, eat, &c")
	(printout t crlf "Your goal is to graduate")
	(printout t crlf "To take classes, get the schedule from Registration")
	(printout t crlf "Drop it in classrooms to take those classes")
	(printout t crlf "You also need to sleep, eat, get a summer job, and go through a job interview")
	(printout t crlf "To start, go south to get the campus map")
	(retract ?input)
)


;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;  Describing the current location of the player when he possesses the campus map.
;; NOTE: superfluous conditions and attributes have been added so that combined with
;; recency and specificity this rule fires before the immediately following ones.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;here added more things
(defrule location_info
	(mode (status run))
	(input describe|look|see|spot|rubberneck|gaze)
	(person (location ?x)) 
	(place (name ?x) (info ?y&~nil))
	(objct (name map) (location player))
	=>
	(printout t crlf "You are at " ?x crlf ?y crlf))

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;   The following productions prompt user about the places to the north, south, east
;; and west (if present) to the current location if he has the campus map
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule see_north
	(input describe|look|see|spot|rubberneck|gaze)
	(person (location ?x))
	(place (name ?n) (south ?x))
	(objct (name map) (location player))
	=>
	(printout t crlf ?n " is to the north.")
)
(defrule see_south
	(input describe|look|see|spot|rubberneck|gaze)
	(person (location ?x))
	(place (name ?n) (north ?x))
	(objct (name map) (location player))
	=>
	(printout t crlf ?n " is to the south.")
)
(defrule see_east
	(input describe|look|see|spot|rubberneck|gaze)
	(person (location ?x))
	(place (name ?n) (west ?x))
	(objct (name map) (location player))
	=>
	(printout t crlf ?n " is to the east.")
)
(defrule see_west
	(input describe|look|see|spot|rubberneck|gaze)
	(person (location ?x))
	(place (name ?n) (east ?x))
	(objct (name map) (location player))
	=>
	(printout t crlf ?n " is to the west.")
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;  Describing current location to the user if he does not have campus map. NOTE: there
;; is a superfluous 4th condition on LHS to make this rule fire before see_objcts.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule without_map_info
	(input describe|look|see|spot|rubberneck|gaze)
	(person (location ?x))
	(not (objct (name map) (location player)))
	(place (name ?x) (info ?y&~nil))
	(person (Credits ?c))
	=>
	(printout t crlf "You are at " ?x)
	(printout t crlf "Get a map to learn more"))

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;  Describes whatever the player can see in the current location
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule see_objcts
	(input describe|look|see|spot|rubberneck|gaze)
	(input describe|look)
	(objct (location ?x) (name ?name))
	(person (location ?x))
	=>
	(printout t crlf "You see a " ?name)
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;  The less specific rule which removes the input after it has been processed.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule remove_describe
	?input <- (input describe|look)
	 =>
	 (retract ?input))
	
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;  Lists the objcts in possession of the player
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule have_objcts
	(input status|score|inventory)
	(objct (location player) (name ?name))
	=>
	(printout t crlf "You have a " ?name)
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;; Prints status information
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule current_status
	 (input status|score|inventory)
	 (person (Credits ?c) (Salary ?s) (Ate ?a) (Slept ?sl) (Moves ?m))
	 =>
	 (printout t crlf "You have " ?c " credits.")
	 (printout t crlf "Your salary is " ?s) 
	 (printout t crlf "You have ate " ?a " times.")
	 (printout t crlf "You have slept " ?sl " times.")
	 (printout t crlf "You have made " ?m " moves."))

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	Less specifice default rule to remove command after processing.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule remove_status
	 ?input <- (input status|score|inventory)
	 =>
	 (retract ?input))

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;  Production to aid player if he loses campus map
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;HERE added more productions
(defrule lost
	(not (objct (name map) (location player)))
	(person (location ?u))
	(not (person (location Orientation)))
	(objct (name pizza))
	(place (name Kendall))
	(place (name Skelly))
	=>
	(printout t crlf "Looks like everybody's going south to get maps.")
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The following productions processes the directional movement command by first
;;  changing the position as asked and then describing the new position with the help
;;  of other productions which describes current location of the player. Also increments
;;  the number of moves made by the player.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule go_south
	?input <- (input s|south) ;|)
	?person <- (person (location ?u) (Moves ?m))
	(place (north ?u) (name ?s))
	=>
	(printout t crlf "You go south, from " ?u " to " ?s)
	(modify ?person (location ?s) (Moves (+ 1 ?m)))
	(retract ?input))

(defrule go_north
	?input <- (input n|north) ;|)
	?person <- (person (location ?u) (Moves ?m))
	(place (south ?u) (name ?s))
	=>
	(printout t crlf "You go north, from " ?u " to " ?s)
	(modify ?person (location ?s) (Moves (+ 1 ?m)))
	(retract ?input))

(defrule go_east
	?input <- (input e|east) ;|)
	?person <- (person (location ?u) (Moves ?m))
	(place (west ?u) (name ?s))
	=>
	(printout t crlf "You go east, from " ?u " to " ?s)
	(modify ?person (location ?s) (Moves (+ 1 ?m)))
	(retract ?input))

(defrule go_west
	?input <- (input w|west) ;|)
	?person <- (person (location ?u) (Moves ?m))
	(place (east ?u) (name ?s))
	=>
	(printout t crlf "You go west, from " ?u " to " ?s)
	(modify ?person (location ?s) (Moves (+ 1 ?m)))
	(retract ?input))

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The following production checks if a closed door prevents the player from 
;;  moving in the direction he desires, and prompts him so. NOTE: only 3 doors are
;;  closed and the player can be stopped by these if he tries to move either east, west
;;  or north from ACAC and the corresponding door is closed.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule closed_door_north
	?input <- (input n|north)
	?person <- (person (location ACAC))
	(door (name grad) (status closed))
	=>
	(printout t crlf "The door to graduation is closed!")
	(retract ?input)
)
(defrule closed_door_west
	?input <- (input w|west)
	?person <- (person (location ACAC))
	(door (name sum_job) (status closed))
	=>
	(printout t crlf "The door to summer job is closed!")
	(retract ?input)
)
(defrule closed_door_east
	?input <- (input e|east)
	?person <- (person (location ACAC))
	(door (name job_int) (status closed))
	=>
	(printout t crlf "The door to job interview is closed!")
	(retract ?input)
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	Less specific default rule to handle the case where it is not possible to
;;  carry out players request for directional movement (i.e., a wall blocks his way).
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule wall
	?input <- (input n|north|e|east|w|west|s|south) ;|)
	=>
	(printout t crlf "OUCH! That's a WALL!!.")
	(retract ?input))

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	Allows the player to sleep only if he is in his Dorm room; increments number of
;;  moves and number of times he slept.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule to_sleep
	?input <- (input sleep|doze|crash|nap|snooze)
	?person <- (person (location Dorm_Room) (Slept ?s) (Moves ?m))
	=>
	(printout t crlf "Goodnight, sweet prince.")
	(printout t crlf "You wake up, ready to face the day.")
	(modify ?person (Slept (+ 1 ?s)) (Moves (+ 1 ?m)))
	(retract ?input))

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	Prevents player from sleeping at any other position.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule cant_sleep
	?input <- (input sleep|doze|crash|nap|snooze)
	(not (person (location Dorm_Room)))
	=>
	(printout t crlf "OAK: There's a time and place for everything.")
	(printout t crlf "You can't sleep here!")
	(retract ?input)
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	If the player asks for a certain objct, and if the objct happens to be located
;;  at the same position as the player, then the location field of the objct is changed
;;  to `player', i.e., the player is given the objct. Increments number of moves.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule get_specific_objct
	?obj <- (objct (location ?x) (name ?name))
	?input <- (input get|grab|pickup|grasp|take ?name)
	?person <- (person (location ?x) (Moves ?m))
	(place (name Graduation))
	=>
	(modify ?obj (location player))
	(modify ?person (Moves (+ 1 ?m)))
	(printout t crlf "You pick up the " ?name)
	(retract ?input)
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The objct asked for by the player is not at the same location.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule cannot_get_specific_objct
	?obj <- (objct (location ?x) (name ?name))
	?input <- (input get|grab|pickup|grasp|take ?name)
	(not (person (location ?x)))
	=>
	(printout t crlf "There is no " ?name " here")
	(retract ?input)
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	Handles the command without arguments, by finding any objct present at that
;;  location.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule get_any_objct
	?input <- (input get|pick|grab)
	?person <- (person (location ?x) (Moves ?m))
	?obj <- (objct (location ?x) (name ?name))
	=>
	(modify ?obj (location player))
	(modify ?person (Moves (+ 1 ?m)))
	(printout t crlf "You pick up the " ?name)
	(retract ?input)
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	There is no objct to pick up in response to a get command without arguments
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule cannot_get_any_objct
	?input <- (input get|pick|grab)
	?obj <- (objct (location ?x) (name ?name))
	(not (person (location ?x)))
	=>
	(printout t crlf "There is nothing to pick up here" ?name)
	(retract ?input)
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The following productions regenerate campus map, and Dorm foods
;;  when one is taken by the player.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule regenerate_map
	(not (objct (name map) (location Orientation)))
	(objct (name map) (location player))
	(person (location ?x))
	(place (name Orientation))
	=>
	(printout t crlf "Somebody sets out another map")
	(assert (objct (name map) (location Orientation) (isa paper)))
)

;; HERE added production to make thing work (person)
(defrule regenerateFood
	(or (not (objct (name salad) (location Cafetaria)))
		(not (objct (name pizza) (location Cafetaria))))
	(person (location ?x))
	(place (name Orientation))
	=>
	(printout t crlf "An employee sets out more food")
	(assert (objct (name salad) (location Cafetaria) (isa food)))
	(assert (objct (name pizza) (location Cafetaria) (isa food)))
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The player is allowed to eat an objct if he possesses that objct and the
;; objct belongs to a class (isa) of objcts that is edible. 
;; Increments number of moves and number of times he ate.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule eat_specific_objct
	?obj <- (objct (location player) (name ?name) (isa food))
	?input <- (input eat|consume|munch ?name)
	?person <- (person (Moves ?m) (Ate ?a))
	=>
	(modify ?person (Moves (+ 1 ?m)) (Ate (+ 1 ?a)))
	(printout t crlf "You eat the " ?name)
	(retract ?obj)
	(retract ?input)
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The player is prevented from eating an objct which belongs to a class of 
;;  objcts that is not edible.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule not_edible_objct
	;all non-food objects are paper
	?obj <- (objct (location player) (name ?name) (isa paper))
	?input <- (input eat|consume|munch ?name)
	=>
	(printout t crlf "You cannot eat a " ?name "!")
	(retract ?input)
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	Handles the command eat without any argument. Checks to see if the player has
;;  anything in his possession that belongs to a class of objcts which are edible.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule eat_anything
	?obj <- (objct (location player) (name ?name) (isa food))
	?input <- (input eat|consume|munch)
	?person <- (person (Moves ?m) (Ate ?a))
	=>
	(modify ?person (Moves (+ 1 ?m)) (Ate (+ 1 ?a)))
	(printout t crlf "You eat the " ?name)
	(retract ?obj)
	(retract ?input)
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;    The player has nothing that he can eat.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule cannot_eat_anything
	(not (objct (location player) (name ?name) (isa food)))
	?input <- (input eat|consume|munch)
	=>
	(printout t crlf "You don't have any food :(")
	(retract ?input)
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The player allowed to drop a specific objct if he has that in his possession.
;;  Increments the number of moves.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule drop_specific_objct
	?obj <- (objct (location player) (name ?name))
	?input <- (input drop|give|submit|release ?name)
	?person <- (person (location ?x) (Moves ?m))
	=>
	(modify ?person (Moves (+ 1 ?m)))
	(modify ?obj (location ?x))
	(printout t crlf "You drop the " ?name)
	(retract ?input)
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The player cannot drop anything that he does not possess.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule cannot_drop_specific_objct
	(not (objct (location player) (name ?name)))
	?input <- (input drop|give|submit|release ?name)
	(person (location ?x))
	=>
	(printout t crlf "You don't have a " ?name " to drop")
	(retract ?input)
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	In response to a drop command without arguments, finds the first thing in
;;  possession of the player and fires the more specific rule with this objct to drop.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule drop_any_objct
	?input <- (input drop|give|submit|release)
	?obj <- (objct (location player) (name ?name))
	?person <- (person (location ?x) (Moves ?m))
	=>
	(modify ?person (Moves (+ 1 ?m)))
	(modify ?obj (location ?x))
	(printout t crlf "You drop the " ?name)
	(retract ?input)
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	There is nothing in possession of the player to drop.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule cannot_drop_any_objct
	?input <- (input drop|give|submit|release)
	(not (objct (location player) (name ?name)))
	(person (location ?x))
	=>
	(printout t crlf "You don't have anything to drop")
	(retract ?input)
)	

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The following productions create the different grade objcts when the proper
;;  grade (for prerequisite course) or the class_schedule is dropped in a classroom.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;; gotta make these fire before incredment_grade
(defrule create_1043_grade
	(objct (name schedule) (location 1043))
	(person (Credits ?c))
	(not (objct (name 1043_grade)))
	(not (objct (name 2003_grade)))
	(not (objct (name 3123_grade)))
	(not (objct (name 4253_grade)))
	(person (location 1043))
	=>
	(printout t crlf "Your grade for 1043 has been posted")
	(assert (objct (name 1043_grade) (location 1043) (isa paper) (used false)))
)
(defrule create_2003_grade
	(or (objct (name schedule) (location 2003)) (objct (name 1043_grade) (location 2003)))
	(person (Credits ?c))
	(not (objct (name 2003_grade)))
	(not (objct (name 3123_grade)))
	(not (objct (name 4253_grade)))
	(person (location 2003))
	=>
	(printout t crlf "Your grade for 2003 has been posted")
	(assert (objct (name 2003_grade) (location 2003) (isa paper) (used false)))
)
(defrule create_3123_grade
	(or (objct (name schedule) (location 3123)) (objct (name 2003_grade) (location 3123)))
	(person (Credits ?c))
	(not (objct (name 3123_grade)))
	(not (objct (name 4253_grade)))
	(person (location 3123))
	=>
	(printout t crlf "Your grade for 3123 has been posted")
	(assert (objct (name 3123_grade) (location 3123) (isa paper) (used false)))
)
(defrule create_4253_grade
	(or (objct (name schedule) (location 4253)) (objct (name 3123_grade) (location 4253)))
	(person (Credits ?c))
	(not (objct (name 4253_grade)))
	(person (location 4253))
	=>
	(printout t crlf "Your grade for 4253 has been posted")
	(assert (objct (name 4253_grade) (location 4253) (isa paper) (used false)))
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The door to summer job is opened when the player gets the grade for any course
;;  and the door is not already open.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule open_summer_job
	?door <- (door (name sum_job) (status closed))
	(person (Credits ?cred))
	(test (> ?cred 0))
	=>
	(printout t crlf "Opening summer job door")
	(modify ?door (status open))
)
(defrule open_job_interview
	?door <- (door (name job_int) (status closed))
	(person (location Summer_Job))
	=>
	(printout t crlf "You did great at your summer job")
	(printout t crlf "Opening door to job interview")
	(modify ?door (status open))
)
(defrule open_graduation
	?door <- (door (name grad) (status closed))
	(objct (name 4253_grade) (location player))
	(person (Salary ?s))
	(test (> ?s 0))
	=>
	(printout t crlf "Opening door to graduation")
	(printout t crlf "Go on, now git!")
	(modify ?door (status open))
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	Graduation door closed if the player does not have 4253 grade with him
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule close_graduation
	?door <- (door (direction north) (status open))
	(objct (name 4253_grade) (location ?x&~player))
	=>
	(printout t "Closing graduation door" crlf)
	(modify ?door (status closed)))

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The following rules assign credits to the player. If the first course taken by
;;  the player is 1043 he gets one credit, other courses taken first fetches him .5 
;;  credits. Any subsequent course taken fetches an additional 1 credit.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule give_first_credit_1
	?o <- (objct (name 1043_grade) (location player) (used false))
	?person <- (person (Credits ?c))
	(test (<= ?c 0))
	=>
	(modify ?o (used true))
	(printout	t crlf "You get a full credit for taking 1043 first")
	(modify ?person (Credits (+ 1 ?c)))
)
(defrule give_first_credit_2
	(or 
		(objct (name 2003_grade) (location player) (used false))
		(objct (name 3123_grade) (location player) (used false))
		(objct (name 4253_grade) (location player) (used false)))
	?o <- (objct (location player) (used false))
	?person <- (person (Credits ?c))
	(test (<= ?c 0))
	=>
	(modify ?o (used true))
	(printout	t crlf "You get 1/2 credit, since you didn't start with 1043")
	(modify ?person (Credits (+ 0.5 ?c)))
)
(defrule give_more_credit
	(or 
		(objct (name 2003_grade) (location player) (used false))
		(objct (name 3123_grade) (location player) (used false))
		(objct (name 4253_grade) (location player) (used false)))
	?o <- (objct (location player) (used false))
	?person <- (person (Credits ?c))
	(test (> ?c 0))
	=>
	(modify ?o (used true))
	(printout	t crlf "You get a full credit for this class")
	(modify ?person (Credits (+ 1 ?c)))
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The following productions check to see if the player has ate and slept at least
;;  once, and eaten or slept a total of four times. If not, 1 is subtracted from the 
;;  number of credits.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule slept_once?
	?person <- (person (Slept ?slept) (Ate ?ate) (Credits ?cred))
	(objct (name diploma) (location player))
	(test (< ?slept 1))
	=>
	(printout t crlf "You didn't sleep at all!")
	(modify ?person (Credits (- ?cred 1)) (Slept 4) (Ate 4))
)
(defrule ate_once?
	?person <- (person (Slept ?slept) (Ate ?ate) (Credits ?cred))
	(objct (name diploma) (location player))
	(test (>= ?slept 1))
	(test (< ?ate 1))
	=>
	(printout t crlf "You didn't eat at all!")
	(modify ?person (Credits (- ?cred 1)) (Slept 4) (Ate 4))
)

(defrule ate_slept_constraint
	?person <- (person (Slept ?slept) (Ate ?ate) (Credits ?cred))
	(objct (name diploma) (location player))
	(test (>= ?slept 1))
	(test (>= ?ate 1))
	(test (< (+ ?ate ?slept) 4))
	=>
	(printout t crlf "You didn't sleep and/or eat a total of four times!")
	(modify ?person (Credits (- ?cred 1)) (Slept 4) (Ate 4))
)


;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	Salary fixed according to the number of credits earned once player moves into 
;;  the permanent job interview room.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule assign_salary
	?p <- (person (Credits ?c) (Salary ?s) (location Job_Interview))
	(test (!= ?s (* 10000 ?c)))	
	=>
	(modify ?p (Salary (* 10000 ?c)))
	(printout t crlf "Good interview! Your salary is " (* 10000 ?c))
)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	Once the player gets diploma, the game is over. He is congratulated, and
;;  his credits, salary, number of moves and computed score is printed out.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule the_end
	(person (Credits ?c) (Salary ?s) (Moves ?m))
	(objct (name diploma) (location player))
	=>
	(printout t crlf "Congratulations on completing your college adventure at TU!")
	(printout t crlf "You have " ?c " credits.")
	(printout t crlf "Your salary will be $" ?s)
	(printout t crlf "You took " ?m " moves.")
	(printout t crlf "Your final score is : " (/ (* ?c ?s) ?m) crlf)
	(halt))
