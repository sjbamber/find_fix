
// Add class to solution textarea on click
$(document).ready(function() {
		$( ".solution_textarea" ).click(function() {
			$( ".solution_textarea" ).addClass( "set_height_250px", 1000 );
			return false;
		});
});