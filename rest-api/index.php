<?php
session_start();
include_once('functions.php');
require('simple_html_dom.php');

if(!isset($_GET['q'])) { 
    return;
} 

$query = $_GET['q'];
$query= strtolower($query);   
$MAX_RESULTS = 5;


$diff =  strtotime(date("Y-m-d H:i:s")) - strtotime($_SESSION['spotify_ts']);
if($diff > 3590 || !isset($_SESSION['spotify_ts'])) {  
  
    $client_id = 'aa344dbc47ee4c009d9ecba2234026ce'; 
    $client_secret = 'e1d16c44b9854192882af0d31fffca0e'; 
    $response = postData('https://accounts.spotify.com/api/token',[ 
        'form_params' =>
            [
                'grant_type' => 'client_credentials',  
                'scope' => 'user-read-private',
            ],
        'headers' =>
            [
                'Content-Type' => 'application/x-www-form-urlencoded',
                'Authorization' => 'Basic '.base64_encode($client_id.':'.$client_secret),
            ],
    ]);
    $_SESSION['spotify_ts'] = date("Y-m-d H:i:s");
    $_SESSION['spotify_auth'] = json_decode($response)->access_token;
}

$content = getData($query);
$soundCloudContent = json_decode($content['soundcloud']);
$spotifyContent = json_decode($content['spotify']);
$youTubeContent = str_get_html($content['youtube']);

//***************************************************//
//*********   YOUTUBE
//***************************************************//
$youtube = [];
$i = 1;

foreach ($youTubeContent->find('div.yt-lockup-dismissable') as $video) {       
        if ($i > $MAX_RESULTS) break;
        

        $image_url =  $video->find('img',0)->src;
        $info = $video->find('div.yt-lockup-content',0); 

        $line = $info->find('a.yt-uix-tile-link', 0);
        $title = $line->title;
        //$title = str_replace('"',"'",$title);
        $id = $line->href;
        $artist = $info->find('div.yt-lockup-byline',0)->find('a',0)->plaintext;        
        $duration = $info->find('span.accessible-description', 0)->plaintext;
      
        $pos = strpos($duration, '- Dauer: ');
        $length = substr($duration,$pos +9);
        $times = explode(":",$length);
        $duration = $times[0] * 60 +$times[1] * 1000;

        $youtube[] = [
            'title' => $title,
            'id' => $id,            
            'duration' => $duration,
            'artist' => $artist,
            'image_url' => $image_url,
        ];  
        
        $i++;
}

//***************************************************//
//*********   SOUNDCLOUD
//***************************************************//
$soundCloud = [];
$i = 1;

foreach($soundCloudContent->collection as $song) {
    if($i > $MAX_RESULTS) break;   

    $soundCloud[] = [
        'title' => $song->title,
        'id' => $song->id,      
        'duration' => $song->duration,
        'artist' => $song->user->username,
        'image_url' => $song->user->avatar_url,
    ]; 
    $i++;
}

//***************************************************//
//*********   SPOTIFY
//***************************************************//
$spotify = [];
$i = 1;

foreach($spotifyContent->tracks->items as $song) {
    if($i > $MAX_RESULTS) break;
   
    $spotify[] = [
        'title' => $song->name,
        'id' => $song->id,      
        'duration' => $song->duration_ms,
        'artist' => $song->artists[0]->name,
        'image_url' => $song->album->images[0]->url,
    ]; 
   
    $i++;
}

$results = [
    'youtube' => $youtube,
    'soundcloud' =>$soundCloud,
    'spotify' => $spotify,
];
echo json_encode($results, JSON_PRETTY_PRINT);

?>