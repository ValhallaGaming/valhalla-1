languages = {
	"English",
	"Russian",
	"German",
	"French",
	"Dutch",
	"Italian",
	"Spanish",
	"Gaelic",
	"Japanese",
	"Chinese",
	"Arabic",
	"Norwegian",
	"Swedish",
	"Danish",
	"Welsh",
	"Hungarian",
	"Bosnian",
	"Somalian",
	"Finnish",
	"Georgian",
	"Greek",
	"Polish",
	"Portugese",
	"Turkish",
	"Estonian",
	"Korean",
	"Vietnamese"
}
	
flags = {
	"gb",
	"ru",
	"de",
	"fr",
	"nl",
	"it",
	"es",
	"sc",
	"ja",
	"cn",
	"af",
	"no",
	"se",
	"dk",
	"gb",
	"hu",
	"bo",
	"so",
	"fi",
	"gy",
	"eu",
	"pl",
	"pr",
	"eu",
	"ee",
	"kr",
	"vn"
}


function getLanguageName(language)
	return languages[language]
end

function getLanguageCount()
	return #languages
end
