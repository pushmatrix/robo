playerPos = x: 0, y: 0
tileSize = 50
turnLength = 1
gameLoop = null
turnCount = 0
player = null
editor = null
  
map = [[' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' '],
       [' ', ' ', ' ', ' ', ' ', ' ']]

rows = map.length
cols = map[0].length

class Robot
  constructor: (@row, @col) ->
    @node = $(document.createElement('div'))
    @node.addClass('robot')
    @node.css('left', col * tileSize)
    @node.css('top',  row * tileSize)
    #@node.width(tileSize).height(tileSize)
    $('#board').append(@node)
  move: (x, y) ->
    @node = $(".robot:first")
    @row += y
    @col += x
    if @row < 0 then @row = 0
    if @row >= rows then @row = (rows - 1)
    if @col < 0 then @col = 0
    if @col >= cols then @col = (cols - 1)
    @node.css('left', @col * tileSize)
    @node.css('top',  @row * tileSize)
  moveLeft: ->
    @move(-1, 0)
    @node.removeClass('left right up down')
    @node.addClass('left')
  moveRight: ->
    @move(1, 0)
    @node.removeClass('left right up down')
    @node.addClass('right')
  moveUp: ->
    @move(0, -1)
    @node.removeClass('left right up down')
    @node.addClass('up')
  moveDown: ->
    @move(0, 1)
    @node.removeClass('left right up down')
    @node.addClass('down')
  set: (x, y) ->
    @row = 0
    @col = 0
    @node.css('left', x * tileSize)
    @node.css('top',  y * tileSize)


addTile = (row, col, type) ->
  tile = $(document.createElement('div'))
  tile.addClass('tile').addClass(type)
  tile.width(tileSize).height(tileSize)
  tile.css('left', col * tileSize )
  tile.css('top',  row * tileSize)
  $('#board').append(tile)


addPlayer = (row, col) ->
  player = new Robot(row, col)

createMap = ->
  $('#board').height(tileSize * rows)
  $('#board').width(tileSize * cols)
  for row, i in map
    for col, j in row
      addTile(i, j, 'dirt')


nextTurn = ->
  turnCount++
  console.log("Beginning turn #{turnCount}")
  command = editor.getValue()
  eval(command)


reset = ->
  console.log("Stopping")
  turnCount = 0
  clearInterval(gameLoop)
  player.set(0, 0)

start = ->
  clearInterval(gameLoop)
  gameLoop = setInterval ->
    nextTurn()
  , turnLength * 1000


for command in ['moveLeft', 'moveUp', 'moveRight', 'moveDown']
  do (command) ->
    window[command] = ->
      player[command]()


$ ->
  $('#resetBtn').click ->
    reset()

  $('#runBtn').click ->
    start()

  editor = CodeMirror($("#logic")[0], theme: "twilight")
  createMap()
  addPlayer(0, 0)