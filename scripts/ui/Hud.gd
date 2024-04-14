class_name Hud
extends CanvasLayer

signal pause_pressed
signal fast_frwd_pressed

@onready var need_bars: Dictionary = {
	"Hunger" = $BarsPanel/NeedBarsBox/HungerNeedBar,
	"Energy" = $BarsPanel/NeedBarsBox/EnergyNeedBar,
	"Bladder" = $BarsPanel/NeedBarsBox/BladderNeedBar,
	"Hygiene" = $BarsPanel/NeedBarsBox/HygieneNeedBar,
	"Comfort" = $BarsPanel/NeedBarsBox/ComfortNeedBar,
	"Fun" = $BarsPanel/NeedBarsBox/FunNeedBar,
}

@onready var skill_bars: Dictionary = {
	"Metamorphosis" = $BarsPanel/SkillBarsBox/MetamorphosisSkillBar,
	"Possession" = $BarsPanel/SkillBarsBox/PossessionSkillBar,
	"Precognition" = $BarsPanel/SkillBarsBox/PrecognitionSkillBar,
	"Bargaining" = $BarsPanel/SkillBarsBox/BargainingSkillBar,
}
@onready var skill_labels: Dictionary = {
	"Metamorphosis" = $BarsPanel/SkillBarsBox/MetamorphosisSkillLbl,
	"Possession" = $BarsPanel/SkillBarsBox/PossessionSkillLbl,
	"Precognition" = $BarsPanel/SkillBarsBox/PrecognitionSkillLbl,
	"Bargaining" = $BarsPanel/SkillBarsBox/BargainingSkillLbl,
}

@onready var clock: Label = $Clock
@onready var date: Label = $Date

@onready var summon_panel: Container = $SummonPanelMargin/SummonPanel
@onready var summon_date_label: Label = $SummonPanelMargin/SummonPanel/SummonInfoBox/TitleMargin/SummonTitleBox/DateLbl
@onready var summon_skills: Dictionary = {
	"Metamorphosis": $SummonPanelMargin/SummonPanel/SummonInfoBox/RequirementsMargin/SkillsBox/MetamorphosisLbl,
	"Possession": $SummonPanelMargin/SummonPanel/SummonInfoBox/RequirementsMargin/SkillsBox/PossessionLbl,
	"Precognition": $SummonPanelMargin/SummonPanel/SummonInfoBox/RequirementsMargin/SkillsBox/PrecognitionLbl,
	"Bargaining": $SummonPanelMargin/SummonPanel/SummonInfoBox/RequirementsMargin/SkillsBox/BargainingLbl,
}
@onready var summon_sound: AudioStreamPlayer = $SummonAlertSound
@onready var summon_success_panel: Container = $SummonSuccessPanelMargin/SummonSuccessPanel

func _ready():
	hide_summon_alert()
	hide_summon_success()

func _on_pause_btn_pressed():
	pause_pressed.emit()
func _on_fast_frwd_btn_pressed():
	fast_frwd_pressed.emit()

func update_need_bar(need_name: String, _old_val: int, new_val: int):
	if need_name == "Mood":
		pass
		# TODO update mood bar?
	else:
		need_bars[need_name].value = new_val

func update_skill_bar
(
	skill_name: String,
	_old_lvl: int, _old_exp: int,
	new_lvl: int, new_exp:int,
	lvl_up: int
):
	skill_bars[skill_name].value = new_exp
	skill_bars[skill_name].max_value = lvl_up
	skill_labels[skill_name].set_text(str(skill_name, " LVL ", str(new_lvl).pad_zeros(2)))

func update_clock(curr_day: int, curr_time: int):
	date.set_text(str("Day ", curr_day + 1))
	var hour_str: String = str((curr_time / 60)).pad_zeros(2)
	var min_str: String = str(curr_time % 60).pad_zeros(2)
	clock.set_text(hour_str + ":" + min_str)

func prepare_summon_alert(summon: Summon):
	var datetime_str = str(
		"Day ", summon.day_start + 1,
		" ", str(summon.time_start / 60).pad_zeros(2),
		":", str(summon.time_start % 60).pad_zeros(2)
	)
	summon_date_label.set_text(datetime_str)
	
	for s_name in summon_skills:
		summon_skills[s_name].set_text("")
	for s_name in summon.req_skills:
		var skill_text: String = ""
		if summon.req_skills[s_name] > 0:
			skill_text = str(s_name, " LVL ", str(summon.req_skills[s_name]).pad_zeros(2))
		summon_skills[s_name].set_text(skill_text)

func show_summon_alert():
	if not summon_panel.visible:
		summon_panel.visible = true
		summon_sound.play()

func hide_summon_alert():
	summon_panel.visible = false
	
func show_summon_success():
	summon_success_panel.visible = true

func hide_summon_success():
	summon_success_panel.visible = false
