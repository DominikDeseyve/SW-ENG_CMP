<?php
require 'vendor/autoload.php';

use GuzzleHttp\Client;
use GuzzleHttp\Psr7\Request;
use GuzzleHttp\Promise;



function getData($pQuery) {
    $MAX_RESULTS = 5;
    $client = new Client([    
        'timeout'  => 2,
    ]);
   
    $promises = [
        'spotify' =>  $client->getAsync("https://api.spotify.com/v1/search?market=de&type=track&limit=$MAX_RESULTS&q=".$pQuery,
            ['headers' =>
                [
                    'Authorization' => "Bearer ".$_SESSION['spotify_auth'],
                ]
            ])->then(
                function ($response) {
                    return $response->getBody();
                }, function ($exception) {
                    return $exception->getMessage();
                }
            ),
        'youtube' => $client->getAsync('https://www.youtube.com/results?search_query='.$pQuery.'&sp=EgIQAQ%253D%253D')->then(
            function ($response) {
                return $response->getBody();
            }, function ($exception) {
                return $exception->getMessage();
            }
        ),
        'soundcloud' => $client->getAsync('https://api-v2.soundcloud.com/search/tracks?client_id=TyQAtemcOqFFQTCV2qqy3rmP9cOn066j&limit=$MAX_RESULTS&q='.$pQuery)->then(
            function ($response) {
                return $response->getBody();
            }, function ($exception) {
                return $exception->getMessage();
            }
        ),
    ];
     
    $responses = Promise\unwrap($promises);
    return $responses;  
}

function postData($url, $header) {
    $client = new Client([    
        'timeout'  => 200,
    ]);
    
    try {
        $response = $client->request('POST', $url, $header);       
        return $response->getBody();
        
    } catch (Exception $e) {
        echo $e;
    }
}

?>