class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum: int = 0


func add_item(item, weight: int):
    items.append({"item": item, "weight": weight})
    weight_sum += weight


func remove_item(item_to_remove):
    for item in items:
        if item.item == item_to_remove:
            items.erase(item)
            weight_sum -= item.weight
            break


func pick_item():
    return pick_items()[0]


func pick_items(count: int = 1) -> Array:
    var adj_items: Array[Dictionary] = items.duplicate()
    var adj_weight_sum: int = weight_sum
    var return_items: Array = []

    for i in min(count, items.size()):
        var rand_val = randi_range(1, adj_weight_sum)
        var iter_sum = 0
        for item in adj_items:
            iter_sum += item.weight
            if rand_val <= iter_sum:
                return_items.append(item.item)
                adj_items.erase(item)
                adj_weight_sum -= item.weight
                break

    return return_items
