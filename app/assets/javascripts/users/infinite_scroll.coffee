$ ->

	$('.card-deck').infiniteScroll({
		path: 'users?page={{#}}',
		append: '.card',
		history: false,
		hideNav: '.pagination',
		button: '.view-more-button',
		scrollThreshold: false,
		status: '.page-load-status',
		checkLastPage: '.page-next',
		loadOnScroll: false
	});

	$('#like-list').infiniteScroll({
		path: 'likes?page={{#}}',
		append: '#user-heart',
		history: false,
		hideNav: '.pagination',
		scrollThreshold: 200,
		status: '.page-load-status',
		checkLastPage: '.page-next',
		elementScroll: '#like-list',
		loadOnScroll: true
	});
