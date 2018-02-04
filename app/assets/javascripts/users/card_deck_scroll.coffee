$ ->
	$('.card-deck').infiniteScroll({
	  path: 'users?page={{#}}',
	  append: '.card',
	  history: false,
		hideNav: '.pagination'
		loadingText: 'Loading new items…'
	});
