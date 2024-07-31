extends Control

func _ready():
	MobileAds.load_banner()
	MobileAds.load_interstitial()
	var RealSize = OS.get_real_window_size()
	var NowSize = OS.get_window_safe_area()
	var notchSizeY = RealSize.y - NowSize.size.y

	if notchSizeY >= 5:
		$OverMenu.rect_position.y = notchSizeY
		$OverMenu.rect_position.y = notchSizeY + 15
	else:
		$OverMenu.rect_position.y = notchSizeY + 30
		$OverMenu.rect_position.y = notchSizeY + 45
	
	$Label2.text = str(Globals.Score)
	
	match Globals.gamemode:
		"UP":
			Globals.highscore["high_score"]["up"] =  Globals.Score if (Globals.Score > Globals.highscore["high_score"]["up"]) else Globals.highscore["high_score"]["up"]
			$Label4.text = str(Globals.highscore["high_score"]["up"])
			$OverMenu/Label6.text = "無限天堂"
			pass
		"DOWN":
			Globals.highscore["high_score"]["down"] =  Globals.Score if (Globals.Score > Globals.highscore["high_score"]["down"]) else Globals.highscore["high_score"]["down"]
			$Label4.text = str(Globals.highscore["high_score"]["down"])
			$OverMenu/Label6.text = "無限地獄"
			pass
	Globals.save()

func _process(delta):
	if MobileAds.get_is_interstitial_loaded():
		$Restart.disabled = false
		$Menu.disabled = false
	else:
		$Restart.disabled = true
		$Menu.disabled = true
	pass

func _on_Restart_pressed():
	match Globals.gamemode:
		"UP":
			get_tree().change_scene("res://src/MainLevel2.tscn")
			pass
		"DOWN":
			get_tree().change_scene("res://src/MainLevel.tscn")
			pass
	MobileAds.hide_banner()
	MobileAds.destroy_banner()
	MobileAds.show_interstitial()
func _on_Menu_pressed():
	MobileAds.hide_banner()
	MobileAds.destroy_banner()
	MobileAds.show_interstitial()
	get_tree().change_scene("res://src/Start.tscn")
	pass # Replace with function body.


func _on_Exit_pressed():
	get_tree().quit()
	pass # Replace with function body.
	
func _on_MobileAds_banner_loaded():
	print("banner loaded")
	pass

