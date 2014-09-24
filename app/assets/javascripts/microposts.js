// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

// add a character countdown widget to the home page
// $(function(){  // load jquery
	var maxLength = 140;
	$('#micropost_content').keyup(function(){
		var length = $(this).val().length;
		var length = maxLength - length;
		if ( length < 0 )
		{	length = 0  };
		$('#chars').text(length);
	});
// });
