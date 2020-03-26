<?php
/***********************************************/
/***************    EVENTS           ***********/
/***********************************************/
$slim->get('/test', function($request, $response, $args) {    
    $pageID =  $request->getQueryParam('pageID');

    echo "test";
});

?>
