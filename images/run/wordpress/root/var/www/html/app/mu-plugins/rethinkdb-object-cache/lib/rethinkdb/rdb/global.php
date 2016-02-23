<?php

namespace r;

use r\DatumConverter;
use r\Exceptions\RqlDriverError;
use r\Ordering\Asc;
use r\Ordering\Desc;
use r\Queries\Control\Branch;
use r\Queries\Control\Error;
use r\Queries\Control\Http;
use r\Queries\Control\Range;
use r\Queries\Control\RDo;
use r\Queries\Dates\April;
use r\Queries\Dates\August;
use r\Queries\Dates\December;
use r\Queries\Dates\EpochTime;
use r\Queries\Dates\February;
use r\Queries\Dates\Friday;
use r\Queries\Dates\Iso8601;
use r\Queries\Dates\January;
use r\Queries\Dates\July;
use r\Queries\Dates\June;
use r\Queries\Dates\March;
use r\Queries\Dates\May;
use r\Queries\Dates\Monday;
use r\Queries\Dates\November;
use r\Queries\Dates\Now;
use r\Queries\Dates\October;
use r\Queries\Dates\Saturday;
use r\Queries\Dates\September;
use r\Queries\Dates\Sunday;
use r\Queries\Dates\Thursday;
use r\Queries\Dates\Time;
use r\Queries\Dates\Tuesday;
use r\Queries\Dates\Wednesday;
use r\Queries\Dbs\Db;
use r\Queries\Dbs\DbCreate;
use r\Queries\Dbs\DbDrop;
use r\Queries\Dbs\DbList;
use r\Queries\Geo\Circle;
use r\Queries\Geo\Distance;
use r\Queries\Geo\GeoJSON;
use r\Queries\Geo\Intersects;
use r\Queries\Geo\Line;
use r\Queries\Geo\Point;
use r\Queries\Geo\Polygon;
use r\Queries\Manipulation\GetField;
use r\Queries\Math\Add;
use r\Queries\Math\Ceil;
use r\Queries\Math\Div;
use r\Queries\Math\Eq;
use r\Queries\Math\Floor;
use r\Queries\Math\Gt;
use r\Queries\Math\Le;
use r\Queries\Math\Lt;
use r\Queries\Math\Mod;
use r\Queries\Math\Mul;
use r\Queries\Math\Ne;
use r\Queries\Math\Not;
use r\Queries\Math\RAnd;
use r\Queries\Math\ROr;
use r\Queries\Math\Random;
use r\Queries\Math\Round;
use r\Queries\Math\Sub;
use r\Queries\Misc\Maxval;
use r\Queries\Misc\Minval;
use r\Queries\Misc\Uuid;
use r\Queries\Math\Ge;
use r\Queries\Tables\Table;
use r\Queries\Tables\TableCreate;
use r\Queries\Tables\TableDrop;
use r\Queries\Tables\TableList;
use r\Queries\Transformations\MapMultiple;
use r\ValuedQuery\ImplicitVar;
use r\Queries\Control\Js;
use r\ValuedQuery\Json;
use r\ValuedQuery\Literal;
use r\ValuedQuery\RObject;

// ------------- Global functions in namespace r -------------

/**
 * @param null $optsOrHost
 * @param null $port
 * @param null $db
 * @param null $apiKey
 * @param null $timeout
 * @return Connection
 */
function connect($optsOrHost = null, $port = null, $db = null, $apiKey = null, $timeout = null)
{
    return new Connection($optsOrHost, $port, $db, $apiKey, $timeout);
}

/**
 * @param $dbName
 * @return Db
 */
function db($dbName)
{
    return new Db($dbName);
}

/**
 * @param $dbName
 * @return DbCreate
 */
function dbCreate($dbName)
{
    return new DbCreate($dbName);
}

/**
 * @param $dbName
 * @return DbDrop
 */
function dbDrop($dbName)
{
    return new DbDrop($dbName);
}

/**
 * @return DbList
 */
function dbList()
{
    return new DbList();
}

/**
 * @param $tableName
 * @param null $useOutdatedOrOpts
 * @return Table
 */
function table($tableName, $useOutdatedOrOpts = null)
{
    return new Table(null, $tableName, $useOutdatedOrOpts);
}

/**
 * @param $tableName
 * @param null $options
 * @return TableCreate
 */
function tableCreate($tableName, $options = null)
{
    return new TableCreate(null, $tableName, $options);
}

/**
 * @param $tableName
 * @return TableDrop
 */
function tableDrop($tableName)
{
    return new TableDrop(null, $tableName);
}

/**
 * @return TableList
 */
function tableList()
{
    return new TableList(null);
}

/**
 * @param $args
 * @param $inExpr
 * @return RDo
 */
function rDo($args, $inExpr)
{
    return new RDo($args, $inExpr);
}

/**
 * @param Query $test
 * @param $trueBranch
 * @param $falseBranch
 * @return Branch
 */
function branch(Query $test, $trueBranch, $falseBranch)
{
    return new Branch($test, $trueBranch, $falseBranch);
}

/**
 * @param null $attribute
 * @return GetField|ImplicitVar
 */
function row($attribute = null)
{
    if (isset($attribute)) {
        // A shortcut to do row()($attribute)
        return new GetField(new ImplicitVar(), $attribute);
    } else {
        return new ImplicitVar();
    }
}

/**
 * @param $code
 * @param null $timeout
 * @return Js
 */
function js($code, $timeout = null)
{
    return new Js($code, $timeout);
}

/**
 * @param null $message
 * @return Error
 */
function error($message = null)
{
    return new Error($message);
}

/**
 * @param $obj
 * @return array|Datum\StringDatum|Iso8601
 * @throws RqlDriverError
 */
function expr($obj)
{
    if ((is_object($obj) && is_subclass_of($obj, "\\r\\Query"))) {
        return $obj;
    }

    $dc = new DatumConverter;
    return $dc->nativeToDatum($obj);
}

/**
 * @param $str
 * @return array|Datum\StringDatum|Iso8601
 * @throws RqlDriverError
 */
function binary($str)
{
    $encodedStr = base64_encode($str);
    if ($encodedStr === false) {
        throw new RqlDriverError("Failed to Base64 encode '" . $str . "'");
    }
    $pseudo = array('$reql_type$' => 'BINARY', 'data' => $encodedStr);

    $dc = new DatumConverter;
    return $dc->nativeToDatum($pseudo);
}

/**
 * @param $attribute
 * @return Desc
 */
function desc($attribute)
{
    return new Desc($attribute);
}

/**
 * @param $attribute
 * @return Asc
 */
function asc($attribute)
{
    return new Asc($attribute);
}

/**
 * @param $json
 * @return Json
 */
function json($json)
{
    return new Json($json);
}

/**
 * @param $url
 * @param null $opts
 * @return Http
 */
function http($url, $opts = null)
{
    return new Http($url, $opts);
}

/**
 * @param $object
 * @return RObject
 */
function rObject($object)
{
    return new RObject($object);
}

/**
 * r\literal can accept 0 or 1 arguments
 * @return Literal
 */
function literal()
{
    if (func_num_args() == 0) {
        return new Literal();
    } else {
        return new Literal(func_get_arg(0));
    }
}

/**
 * @param $expr1
 * @param $expr2
 * @return Add
 */
function add($expr1, $expr2)
{
    return new Add($expr1, $expr2);
}

/**
 * @param $expr1
 * @param $expr2
 * @return Sub
 */
function sub($expr1, $expr2)
{
    return new Sub($expr1, $expr2);
}

/**
 * @param $expr1
 * @param $expr2
 * @return Mul
 */
function mul($expr1, $expr2)
{
    return new Mul($expr1, $expr2);
}

/**
 * @param $expr1
 * @param $expr2
 * @return Div
 */
function div($expr1, $expr2)
{
    return new Div($expr1, $expr2);
}

/**
 * @param $expr1
 * @param $expr2
 * @return Mod
 */
function mod($expr1, $expr2)
{
    return new Mod($expr1, $expr2);
}

/**
 * @param $expr1
 * @param $expr2
 * @return RAnd
 */
function rAnd($expr1, $expr2)
{
    return new RAnd($expr1, $expr2);
}

/**
 * @param $expr1
 * @param $expr2
 * @return ROr
 */
function rOr($expr1, $expr2)
{
    return new ROr($expr1, $expr2);
}

/**
 * @param $expr1
 * @param $expr2
 * @return Eq
 */
function eq($expr1, $expr2)
{
    return new Eq($expr1, $expr2);
}

/**
 * @param $expr1
 * @param $expr2
 * @return Ne
 */
function ne($expr1, $expr2)
{
    return new Ne($expr1, $expr2);
}

/**
 * @param $expr1
 * @param $expr2
 * @return Gt
 */
function gt($expr1, $expr2)
{
    return new Gt($expr1, $expr2);
}

/**
 * @param $expr1
 * @param $expr2
 * @return Ge
 */
function ge($expr1, $expr2)
{
    return new Ge($expr1, $expr2);
}

/**
 * @param $expr1
 * @param $expr2
 * @return Lt
 */
function lt($expr1, $expr2)
{
    return new Lt($expr1, $expr2);
}

/**
 * @param $expr1
 * @param $expr2
 * @return Le
 */
function le($expr1, $expr2)
{
    return new Le($expr1, $expr2);
}

/**
 * @param $expr
 * @return Not
 */
function not($expr)
{
    return new Not($expr);
}

/**
 * @param null $left
 * @param null $right
 * @param null $opts
 * @return Random
 */
function random($left = null, $right = null, $opts = null)
{
    return new Random($left, $right, $opts);
}

/**
 * @return Now
 */
function now()
{
    return new Now();
}

/**
 * @param $year
 * @param $month
 * @param $day
 * @param null $hourOrTimezone
 * @param null $minute
 * @param null $second
 * @param null $timezone
 * @return Time
 */
function time($year, $month, $day, $hourOrTimezone = null, $minute = null, $second = null, $timezone = null)
{
    return new Time($year, $month, $day, $hourOrTimezone, $minute, $second, $timezone);
}

/**
 * @param $epochTime
 * @return EpochTime
 */
function epochTime($epochTime)
{
    return new EpochTime($epochTime);
}

/**
 * @param $iso8601Date
 * @param null $opts
 * @return Iso8601
 */
function iso8601($iso8601Date, $opts = null)
{
    return new Iso8601($iso8601Date, $opts);
}

/**
 * @return Monday
 */
function monday()
{
    return new Monday();
}

/**
 * @return Tuesday
 */
function tuesday()
{
    return new Tuesday();
}

/**
 * @return Wednesday
 */
function wednesday()
{
    return new Wednesday();
}

/**
 * @return Thursday
 */
function thursday()
{
    return new Thursday();
}

/**
 * @return Friday
 */
function friday()
{
    return new Friday();
}

/**
 * @return Saturday
 */
function saturday()
{
    return new Saturday();
}

/**
 * @return Sunday
 */
function sunday()
{
    return new Sunday();
}

/**
 * @return January
 */
function january()
{
    return new January();
}

/**
 * @return February
 */
function february()
{
    return new February();
}

/**
 * @return March
 */
function march()
{
    return new March();
}

/**
 * @return April
 */
function april()
{
    return new April();
}

/**
 * @return May
 */
function may()
{
    return new May();
}

/**
 * @return June
 */
function june()
{
    return new June();
}

/**
 * @return July
 */
function july()
{
    return new July();
}

/**
 * @return August
 */
function august()
{
    return new August();
}

/**
 * @return September
 */
function september()
{
    return new September();
}

/**
 * @return October
 */
function october()
{
    return new October();
}

/**
 * @return November
 */
function november()
{
    return new November();
}

/**
 * @return December
 */
function december()
{
    return new December();
}

/**
 * @param $geojson
 * @return GeoJSON
 */
function geoJSON($geojson)
{
    return new GeoJSON($geojson);
}

/**
 * @param $lat
 * @param $lon
 * @return Point
 */
function point($lat, $lon)
{
    return new Point($lat, $lon);
}

/**
 * @param $points
 * @return Line
 */
function line($points)
{
    return new Line($points);
}

/**
 * @param $points
 * @return Polygon
 */
function polygon($points)
{
    return new Polygon($points);
}

/**
 * @param $center
 * @param $radius
 * @param null $opts
 * @return Circle
 */
function circle($center, $radius, $opts = null)
{
    return new Circle($center, $radius, $opts);
}

/**
 * @param $g1
 * @param $g2
 * @return Intersects
 */
function intersects($g1, $g2)
{
    return new Intersects($g1, $g2);
}

/**
 * @param $g1
 * @param $g2
 * @param null $opts
 * @return Distance
 */
function distance($g1, $g2, $opts = null)
{
    return new Distance($g1, $g2, $opts);
}

/**
 * @param null $str
 * @return Uuid
 */
function uuid($str = null)
{
    return new Uuid($str);
}

/**
 * @return Minval
 */
function minval()
{
    return new Minval();
}

/**
 * @return Maxval
 */
function maxval()
{
    return new Maxval();
}

/**
 * @param null $startOrEndValue
 * @param null $endValue
 * @return Range
 */
function range($startOrEndValue = null, $endValue = null)
{
    return new Range($startOrEndValue, $endValue);
}

/**
 * @param $sequences
 * @param $mappingFunction
 * @return MapMultiple
 * @throws RqlDriverError
 */
function mapMultiple($sequences, $mappingFunction)
{
    if (!is_array($sequences)) {
        $sequences = array($sequences);
    }
    if (sizeof($sequences) < 1) {
        throw new RqlDriverError("At least one sequence must be passed into r\mapMultiple.");
    }
    return new MapMultiple($sequences[0], array_slice($sequences, 1), $mappingFunction);
}

/**
 * @param $value
 * @return Ceil
 */
function ceil($value)
{
    return new Ceil($value);
}

/**
 * @param $value
 * @return Floor
 */
function floor($value)
{
    return new Floor($value);
}

/**
 * @param $value
 * @return Round
 */
function round($value)
{
    return new Round($value);
}

/**
 * @return string
 */
function systemInfo()
{
    return "PHP-RQL Version: " . PHP_RQL_VERSION . "\n";
}
