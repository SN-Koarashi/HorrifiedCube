extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rewardAd = 0

# Called when the node enters the scene tree for the first time.
func _ready():
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
			OS.alert("Not Ads","ERROR")
	Globals.load()
	$SelMode/OptionButton.add_item("無限天堂 (Endless Heaven)",1)
	$SelMode/OptionButton.add_item("無限地獄 (Endless Hell)",2)
	
	Globals.highscore["coin"] =  Globals.coin if (Globals.coin > Globals.highscore["coin"]) else Globals.highscore["coin"]
	$titles/adreward.text = str(Globals.highscore["coin"])

	MobileAds.load_banner()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if Input.get_action_strength("start"):
		get_tree().change_scene("res://src/MainLevel.tscn")

func _on_start_pressed():
	if $SelMode/OptionButton.selected == 0:
		Globals.gamemode = "UP"
		get_tree().change_scene("res://src/MainLevel2.tscn")
		pass
	else:
		Globals.gamemode = "DOWN"
		get_tree().change_scene("res://src/MainLevel.tscn")
		pass
	MobileAds.hide_banner()
	MobileAds.destroy_banner()
	pass # Replace with function body.


func _on_help_pressed():
	$WindowDialog.popup_centered()
	pass # Replace with function body.


func _on_mode_pressed():
	#Vector2($Menu.rect_position.x,$Menu.rect_position.y)
	$SelMode.popup()
	pass # Replace with function body.


func _on_about_pressed():
	$AboutDia.popup()
	pass # Replace with function body.

func _on_readAd_pressed():
	MobileAds.show_rewarded()
	pass # Replace with function body.

func _on_MobileAds_rewarded_ad_closed():
	if (OS.get_unix_time() - rewardAd) >= 4:
		Globals.coin += 1
		Globals.highscore["coin"] += 1
		Globals.save()
		$titles/adreward.text = str(Globals.highscore["coin"])
	else:
		rewardAd = OS.get_unix_time()

	load_read()
	pass # Replace with function body.

func _process(delta):
	if MobileAds.get_is_rewarded_loaded():
		$Menu/readAd.disabled = false
	else:
		$Menu/readAd.disabled = true
	pass

func load_read():
	MobileAds.load_rewarded()

func _on_MobileAds_rewarded_ad_opened():
	rewardAd = OS.get_unix_time()
	pass # Replace with function body.
	
func _on_MobileAds_initialization_complete(status, _adapter_name):
	if status == MobileAds.AdMobSettings.INITIALIZATION_STATUS.READY:
		MobileAds.load_banner()
		MobileAds.load_rewarded()
	else:
		OS.alert("AdMob not initialized, check your configuration","ERROR")
		
func _on_MobileAds_banner_loaded():
	print("banner loaded")
	pass

#func _on_MobileAds_consent_info_update_failure(error_code, error_message):
#	OS.alert(error_message,"consent_info_update_failure ("+str(error_code)+")")
#	pass
#func _on_MobileAds_consent_status_changed(consent_status_message):
#	OS.alert(consent_status_message,"consent_status_changed)")
#	pass
