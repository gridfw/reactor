###*
 * get/set reactor data logic
###
REACTOR_DATA = Symbol 'Reactor data'
_data = (ele)-> ele[REACTOR_DATA] ?= _create null