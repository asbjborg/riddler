-- Riddler - In-game trivia quiz addon
-- General WoW Knowledge Quiz Template

-- This template will be loaded as a default quiz during the first run

Riddler = Riddler or {}
Riddler.Templates = Riddler.Templates or {}

Riddler.Templates.GeneralWoW = {
    id = "template_general_wow",
    name = "General WoW Knowledge",
    category = "World of Warcraft",
    description = "Test your knowledge of World of Warcraft with these general trivia questions.",
    difficulty = "Medium",
    author = "Riddler Team",
    tags = {"WoW", "Lore", "General"},
    version = "1.0",
    questions = {
        {
            text = "Who was the first Guardian of Tirisfal?",
            type = "multiple_choice",
            choices = {
                "Aegwynn",
                "Medivh",
                "Alodi",
                "Aranda"
            },
            correct_answer = 3,
            difficulty = "Medium",
            explanation = "Alodi was the first Guardian of Tirisfal, chosen approximately 11,500 years ago.",
            category = "Lore",
            duration = 20
        },
        {
            text = "Which expansion introduced the Death Knight class?",
            type = "multiple_choice",
            choices = {
                "The Burning Crusade",
                "Wrath of the Lich King",
                "Cataclysm",
                "Mists of Pandaria"
            },
            correct_answer = 2,
            difficulty = "Easy",
            explanation = "Death Knights were introduced in the second expansion, Wrath of the Lich King.",
            category = "Game Mechanics",
            duration = 15
        },
        {
            text = "Which city serves as the Alliance capital?",
            type = "multiple_choice",
            choices = {
                "Orgrimmar",
                "Stormwind",
                "Dalaran",
                "Silvermoon"
            },
            correct_answer = 2,
            difficulty = "Easy",
            explanation = "Stormwind City is the capital city of the humans and the main Alliance capital.",
            category = "World",
            duration = 10
        },
        {
            text = "Who is the current leader of the Forsaken?",
            type = "multiple_choice",
            choices = {
                "Sylvanas Windrunner",
                "Lillian Voss",
                "Calia Menethil",
                "Derek Proudmoore"
            },
            correct_answer = 3,
            difficulty = "Medium",
            explanation = "Following the events of Shadowlands, Calia Menethil leads the Forsaken alongside the Forsaken Dark Rangers.",
            category = "Lore",
            duration = 20
        },
        {
            text = "What is the name of Thrall's hammer?",
            type = "multiple_choice",
            choices = {
                "Doomhammer",
                "Ashbringer",
                "Frostmourne",
                "Gorehowl"
            },
            correct_answer = 1,
            difficulty = "Easy",
            explanation = "Thrall wields the Doomhammer, which previously belonged to Orgrim Doomhammer.",
            category = "Items",
            duration = 15
        },
        {
            text = "Which of these is NOT one of the original Titan Keepers?",
            type = "multiple_choice",
            choices = {
                "Thorim",
                "Odyn",
                "Helya",
                "Mimiron"
            },
            correct_answer = 3,
            difficulty = "Hard",
            explanation = "Helya was originally a titan-forged sorceress who was transformed into a Val'kyr by Odyn, not one of the original Titan Keepers.",
            category = "Lore",
            duration = 25
        },
        {
            text = "What is the primary gathering profession that pairs with Alchemy?",
            type = "multiple_choice",
            choices = {
                "Mining",
                "Herbalism",
                "Skinning",
                "Enchanting"
            },
            correct_answer = 2,
            difficulty = "Easy",
            explanation = "Herbalism pairs with Alchemy, as herbs are the primary materials used in creating potions and elixirs.",
            category = "Professions",
            duration = 15
        },
        {
            text = "During the First War, which kingdom fell to the Orcish Horde?",
            type = "multiple_choice",
            choices = {
                "Lordaeron",
                "Stormwind",
                "Alterac",
                "Gilneas"
            },
            correct_answer = 2,
            difficulty = "Medium",
            explanation = "The Kingdom of Stormwind fell during the First War when the Orcish Horde invaded Azeroth through the Dark Portal.",
            category = "History",
            duration = 20
        },
        {
            text = "What is the home planet of the Draenei?",
            type = "multiple_choice",
            choices = {
                "Argus",
                "Draenor",
                "Azeroth",
                "K'aresh"
            },
            correct_answer = 1,
            difficulty = "Medium",
            explanation = "The Draenei originated from Argus, which was also the homeworld of the Eredar.",
            category = "Races",
            duration = 20
        },
        {
            text = "Which dragon aspect was corrupted by the Old Gods?",
            type = "multiple_choice",
            choices = {
                "Alexstrasza",
                "Ysera",
                "Nozdormu",
                "Neltharion"
            },
            correct_answer = 4,
            difficulty = "Medium",
            explanation = "Neltharion, the Earth-Warder, was corrupted by the Old Gods and became Deathwing the Destroyer.",
            category = "Dragons",
            duration = 20
        }
    }
} 