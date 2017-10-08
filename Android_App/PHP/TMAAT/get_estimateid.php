<?php
require_once "db.inc.php";
echo '<?xml version="1.0" encoding="UTF-8" ?>';


// Process in a function
process($_GET['estimateid']);

/**
 * Process the query
 * @param $estimateid
 * @param $row individual row
 */
function process($estimateid) {
    // Connect to the database
    $pdo = pdo_connect();
    $estimateidQ = $pdo->quote($estimateid);
    $query = "select id from tmaat_MovingEstimate where id=$estimateidQ";
    $rows = $pdo->query($query);

    if($row = $rows->fetch()) {
        echo '<project status="yes"/>';
    } else {
        echo "<project status=\"no\" msg=\"not there\"/>";
    }
}