extends Node
const FILE_NAME = "user://game-data-v2.json"

var list_plat = []
var Score = 0
var health = 3
var coin = 0
var gamemode = ""
var highscore = {
		"high_score": {
			"up": 0,
			"down": 0
		},
		"coin": 0
	}


func save():
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(highscore))
	file.close()
func load():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			highscore = data
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")

func loadAllAds():
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		MobileAds.request_user_consent()
		if MobileAds.plugin != null:
			# warning-ignore:return_value_discarded
			MobileAds.plugin.connect("consent_info_update_failure", self, "_on_MobileAds_consent_info_update_failure")
			# warning-ignore:return_value_discarded
			MobileAds.plugin.connect("consent_status_changed", self, "_on_MobileAds_consent_status_changed")
			# warning-ignore:return_value_discarded
			MobileAds.plugin.connect("banner_loaded", self, "_on_MobileAds_banner_loaded")
			# warning-ignore:return_value_discarded
			MobileAds.plugin.connect("banner_destroyed", self, "_on_MobileAds_banner_destroyed")
			# warning-ignore:return_value_discarded
			MobileAds.plugin.connect("interstitial_loaded", self, "_on_MobileAds_interstitial_loaded")
			# warning-ignore:return_value_discarded
			MobileAds.plugin.connect("interstitial_closed", self, "_on_MobileAds_interstitial_closed")
			# warning-ignore:return_value_discarded
			MobileAds.plugin.connect("rewarded_ad_loaded", self, "_on_MobileAds_rewarded_ad_loaded")
			# warning-ignore:return_value_discarded
			MobileAds.plugin.connect("rewarded_ad_closed", self, "_on_MobileAds_rewarded_ad_closed")
			# warning-ignore:return_value_discarded
			MobileAds.plugin.connect("rewarded_interstitial_ad_loaded", self, "_on_MobileAds_rewarded_interstitial_ad_loaded")
			# warning-ignore:return_value_discarded
			MobileAds.plugin.connect("rewarded_interstitial_ad_closed", self, "_on_MobileAds_rewarded_interstitial_ad_closed")
			# warning-ignore:return_value_discarded
			MobileAds.plugin.connect("user_earned_rewarded", self, "_on_MobileAds_user_earned_rewarded")
			# warning-ignore:return_value_discarded
			MobileAds.plugin.connect("initialization_complete", self, "_on_MobileAds_initialization_complete")
		else:
			print("Not Ads")
