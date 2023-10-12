class_name PathFinder extends Object

func find_path(heightGrid, bounds: Vector3i, start: Vector2i, end: Vector2i)->Array[HeightBlock]:
	#var gridList: Array[HeightBlock] = heightGrid.map(func(a): return a.flat())
	var openList: Array[HeightBlock] = [ heightGrid[start.x][start.y] ]
	var closedList: Array[HeightBlock] = []
	
	while openList.size() > 0:
		openList.sort_custom(_compare_reverse_F)
		var current: HeightBlock = openList.pop_back()
		closedList.append(current)
		if current.xz == end: 
			return _get_finished_list(heightGrid, start, end)
		
		for location in get_neighbour_tiles(current.xz, bounds):
			var tile: HeightBlock = heightGrid[location.x][location.y]
			if tile.is_blocked() || closedList.has(tile) || _cannot_jump(current, tile):
				continue
			#the following could be in a separate non modifiable class
			#and open list could consist of that
			tile.G = manhatten_distance(start, tile.xz)
			tile.H = manhatten_distance(end, tile.xz)
			tile.previous = current
			if !openList.has(tile):
				openList.append(tile)
	
	return []

func _compare_reverse_F(a: HeightBlock, b: HeightBlock):
	return (a.G+a.H)>(b.G+b.H)
	
func _get_finished_list(heightGrid, start: Vector2i, end: Vector2i)->Array[HeightBlock]:
	var finishedList: Array[HeightBlock] = []
	var current: HeightBlock = heightGrid[end.x][end.y]
	while current.xz != start:
		finishedList.append(current)
		current = current.previous
	finishedList.reverse()
	return finishedList
	
func _cannot_jump(current: HeightBlock, to: HeightBlock):
	return abs(current.height - to.height) > 1

func get_neighbour_tiles(current: Vector2i, bounds: Vector3i)->Array[Vector2i]:
	var toCheck: Array[Vector2i] = []
	var lowX = current.x - 1
	if (lowX >= 0):
		toCheck.append(Vector2i(lowX, current.y))
	var highX = current.x + 1
	if (highX < bounds.x):
		toCheck.append(Vector2i(highX, current.y))	
	var lowZ = current.y - 1
	if (lowZ >= 0):
		toCheck.append(Vector2i(current.x, lowZ))
	var highZ = current.y + 1
	if (highZ < bounds.z):
		toCheck.append(Vector2i(current.x, highZ))
	
	return toCheck

func manhatten_distance(from: Vector2i, to: Vector2i)->int:
	return abs(from.x - to.x) + abs(from.y - to.y)
