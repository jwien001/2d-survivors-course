extends PanelContainer
class_name MetaUpgradeCard

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var count_label: Label = %CountLabel
@onready var progress_label: Label = %ProgressLabel
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var purchase_button: Button = %PurchaseButton

var upgrade: MetaUpgrade


func _ready() -> void:
    purchase_button.pressed.connect(_on_purchase_pressed)


func _on_purchase_pressed():
    if !upgrade: return

    MetaProgression.add_meta_upgrade(upgrade)
    MetaProgression.meta_data["meta_upgrade_currency"] -= upgrade.experience_cost
    MetaProgression.save_data()
    get_tree().call_group("meta_upgrade_card", "update_progress")

    $AnimationPlayer.play("selected")


func select_card():
    $AnimationPlayer.play("selected")


func set_meta_upgrade(upgrade: MetaUpgrade):
    self.upgrade = upgrade

    name_label.text = upgrade.title
    description_label.text = upgrade.description

    update_progress()


func update_progress():
    var quantity = 0
    if MetaProgression.meta_data["meta_upgrades"].has(upgrade.id):
        quantity = MetaProgression.meta_data["meta_upgrades"][upgrade.id]["quantity"]

    var currency = MetaProgression.meta_data["meta_upgrade_currency"]
    var percent = min(float(currency) / upgrade.experience_cost, 1.0)
    var is_maxed = quantity >= upgrade.max_quantity

    count_label.text = "x%d" % quantity
    progress_label.text = str(currency) + "/" + str(upgrade.experience_cost)
    progress_bar.value = percent
    purchase_button.disabled = percent < 1.0 || is_maxed
    if is_maxed:
        purchase_button.text = "Maxed"
