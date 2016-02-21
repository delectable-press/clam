<?php

namespace r\Queries\Dbs;

use r\ValuedQuery\ValuedQuery;
use r\ProtocolBuffer\TermTermType;

/**
 * Class DbCreate
 * @package r\Queries\Dbs
 * @method run
 */
class DbCreate extends ValuedQuery
{
    /**
     * DbCreate constructor.
     * @param $dbName
     */
    public function __construct($dbName)
    {
        $dbName = $this->nativeToDatum($dbName);
        $this->setPositionalArg(0, $dbName);
    }

    /**
     * @return int
     */
    protected function getTermType()
    {
        return TermTermType::PB_DB_CREATE;
    }
}
