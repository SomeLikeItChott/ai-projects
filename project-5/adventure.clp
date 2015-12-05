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
	?input <- (input stop|quit|exit|bye)
	=>
	(retract ?input)
	(halt))

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;; Providing help to the player
;; YOU ARE ENCOURAGED TO ADD OTHER SYNONYMS FOR COMMANDS AND HANDLE THEM APPROPRIATELY
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule help
	?input <- (input help)
	=>
	)


;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;  Describing the current location of the player when he possesses the campus map.
;; NOTE: superfluous conditions and attributes have been added so that combined with
;; recency and specificity this rule fires before the immediately following ones.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule location_info
	 (input describe|look) ;|)
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
	=>
	)
(defrule see_south
	=>
	)
(defrule see_east
	=>
	)
(defrule see_west
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;  Describing current location to the user if he does not have campus map. NOTE: there
;; is a superfluous 4th condition on LHS to make this rule fire before see_objcts.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule without_map_info
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;  Describes whatever the player can see in the current location
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule see_objcts
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;  The less specific rule which removes the input after it has been processed.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule remove_describe
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;  Lists the objcts in possession of the player
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule have_objcts
	=>
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
(defrule lost
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The following productions processes the directional movement command by first
;;  changing the position as asked and then describing the new position with the help
;;  of other productions which describes current location of the player. Also increments
;;  the number of moves made by the player.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule go_south
	?input <- (input s|south)
	=>
	(modify (player location) (north (player location))))

(defrule go_north
	=>
	)

(defrule go_east
	=>
	)

(defrule go_west
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The following production checks if a closed door prevents the player from 
;;  moving in the direction he desires, and prompts him so. NOTE: only 3 doors are
;;  closed and the player can be stopped by these if he tries to move either east, west
;;  or north from ACAC and the corresponding door is closed.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule closed_door_north
	=>
	)
(defrule closed_door_west
	=>
	)
(defrule closed_door_east
	=>
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
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	Prevents player from sleeping at any other position.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule cant_sleep
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	If the player asks for a certain objct, and if the objct happens to be located
;;  at the same position as the player, then the location field of the objct is changed
;;  to `player', i.e., the player is given the objct. Increments number of moves.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule get_specific_objct
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The objct asked for by the player is not at the same location.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule cannot_get_specific_objct
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	Handles the command without arguments, by finding any objct present at that
;;  location.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule get_any_objct
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	There is no objct to pick up in response to a get command without arguments
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule cannot_get_any_objct
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The following productions regenerate campus map, and Dorm foods
;;  when one is taken by the player.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule regenerate_map
	=>
	)
(defrule regenerateFood
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The player is allowed to eat an objct if he possesses that objct and the
;; objct belongs to a class (isa) of objcts that is edible. 
;; Increments number of moves and number of times he ate.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule eat_specific_objct
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The player is prevented from eating an objct which belongs to a class of 
;;  objcts that is not edible.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule not_edible_objct
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	Handles the command eat without any argument. Checks to see if the player has
;;  anything in his possession that belongs to a class of objcts which are edible.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule eat_anything
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;    The player has nothing that he can eat.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule cannot_eat_anything
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The player allowed to drop a specific objct if he has that in his possession.
;;  Increments the number of moves.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule drop_specific_objct
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The player cannot drop anything that he does not possess.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule cannot_drop_specific_objct
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	In response to a drop command without arguments, finds the first thing in
;;  possession of the player and fires the more specific rule with this objct to drop.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule drop_any_objct
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	There is nothing in possession of the player to drop.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule cannot_drop_any_objct
	=>
	)	

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The following productions create the different grade objcts when the proper
;;  grade (for prerequisite course) or the class_schedule is dropped in a classroom.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule create_1043_grade
	=>
	)
(defrule create_2003_grade
	=>
	)
(defrule create_3123_grade
	=>
	)
(defrule create_4253_grade
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The door to summer job is opened when the player gets the grade for any course
;;  and the door is not already open.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule open_summer_job
	=>
	)
(defrule open_job_interview
	=>
	)
(defrule open_graduation
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	Graduation door closed if the player does not have 4253 grade with him
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule close_graduation
	?door <- (door (direction north) (status open))
	(objct (name 4253Grade) (location ?x&~player))
	=>
	(printout t "Closing graduation door" crlf)
	(modify ?door (status closed)))

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The following rules assign credits to the player. If the first course taken by
;;  the player is 1043 he gets one credit, other courses taken first fetches him .5 
;;  credits. Any subsequent course taken fetches an additional 1 credit.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule give_first_credit_1
	=>
	)
(defrule give_first_credit_2
	=>
	)
(defrule give_more_credit
	=>
	)

;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	The following productions check to see if the player has ate and slept at least
;;  once, and eaten or slept a total of four times. If not, 1 is subtracted from the 
;;  number of credits.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule slept_once?
	=>
	)
(defrule ate_once?
	=>
	)

(defrule ate_slept_constraint
	=>
	)


;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;;	Salary fixed according to the number of credits earned once player moves into 
;;  the permanent job interview room.
;;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defrule assign_salary
	=>
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
