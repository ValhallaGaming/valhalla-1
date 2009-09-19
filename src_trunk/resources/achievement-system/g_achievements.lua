local g_achievements = {
	{ "Viva Las Vegas", "Played during the LV Era.", 50 },
	{ "Donut King", "Join the Los Santos Police Department.", 15 },
	{ "The Wheelman", "Enter a vehicle.", 5 },
	{ "The Newbie", "Create your first character.", 10 },
	{ "Trust me, I'm a doctor", "Join the Los Santos Emergency Services.", 15 },
	{ "Politicians, All the same", "Join the Los Santos Government.", 10 },
	{ "Cleaning the streets", "Arrest someone.", 5 },
	{ "Banged Up", "Be arrested.", 5 },
	{ "My Pad","Purchase a house.", 20 },
	{ "Your Very Own Sweatshop!", "Purchase a business.", 20 },
	{ "Just Another Statistic", "Die in a vehicle crash.", 15 },
	{ "Boom, Headshot", "Headshot another player.", 15 },
	{ "Photo Shoot", "Get caught on a speed camera", 25 },
	{ "Trickmaster", "Perform a quick-reload.", 15 },
	{ "In a Body Bag", "Get headshotted", 15 },
	{ "On the Blower", "Make a call.", 10 },
	{ "My Ride", "Purchase your own vehicle.", 25 },
	{ "The Beta Blues", "Took part in a Valhalla MTA Beta Test.", 100 },
	{ "Road Traffic Accident","Die in a Car Crash.", 25 },
	{ "I know Kung-Fu", "Visit the gym and change your fighting style.", 25 },
	{ "Does this make me look fat?", "Purchase clothes from a clothes store.", 15 },
	{ "Shopaholic", "Buy 1 item from a shop.", 15 },
	{ "Ziebrand", "Find the remnants of Wesley Adama.", 100 },
	{ "The English Drunkard", "Find Jack Konstantines missing beer bottle.", 100 },
	{ "The Farmer", "Visit Bens hay stack.", 100 },
	{ "Quite The Enthusiast!", "Read the entire City Guide.", 40 },
	{ "Boat Trip", "Purchase a boat.", 0 },
	{ "All out", "Run out of supplies in your business.", 10 },
	{ "Donator", "Donate to Valhalla Gaming.", 100 },
	{ "Cashin Cheques", "Get a job.", 20 },
	{ "Bank Heist", "Rob the bank.", 20 },
	{ "From Valhalla With Love", "Special thanks to the MTA team for their continous hard work.", 50 },
	{ "Pirate", "Took part in the Valhalla MTA Treasure Hunt Event.", 25 },
	{ "No.1 Pirate", "Completed the Valhalla MTA Treasure Hunt Event.", 25 },
	{ "Whale Hunter", "Catch a fish weighing 100lbs or more.", 50 },
	{ "Quality Assurance", "Took part in the MTA 1.0 2nd Beta Test.", 100 },
	{ "The Good Samaritan", "Donate $1000 or more to charity", 100 },
	{ "Welcome to Los Santos", "Arrive in Los Santos.", 10 },
	{ "Party Time", "Join the 2.1 Relaunch Party.", 100 },
	{ "Where the Past Lies", "Which bones are those in the grave?", 25 },
	{ "Sea World Los Santos", "Survived the 1st Flood of Los Santos.", 100 },
	{ "All Rights Reserved", "You broke the SA-MP License Agreement. Well Done.", 25 }
}

function getAchievementInfo(id)
	if id then
		return g_achievements[id]
	end
end

function getAchievementCount()
	return #g_achievements
end

local totalPoints = 0
for key, value in ipairs(g_achievements) do
	totalPoints = totalPoints + value[3]
end

function getAchievementPoints()
	return totalPoints
end
