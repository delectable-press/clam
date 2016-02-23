<?php

namespace r\Queries\Dbs;

use r\Query;
use r\Queries\Tables\Table;
use r\Queries\Tables\TableCreate;
use r\Queries\Tables\TableDrop;
use r\Queries\Tables\TableList;
use r\Queries\Tables\Reconfigure;
use r\Queries\Tables\Rebalance;
use r\Queries\Tables\Wait;
use r\ProtocolBuffer\TermTermType;

/**
 * Class Db
 * @package r\Queries\Dbs
 */
class Db extends Query
{
    /**
     * Db constructor.
     *
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
        return TermTermType::PB_DB;
    }

    /**
     * @param $tableName
     * @param null $useOutdatedOrOpts
     *
     * @return Table
     */
    public function table($tableName, $useOutdatedOrOpts = null)
    {
        return new Table($this, $tableName, $useOutdatedOrOpts);
    }

    /**
     * @param $tableName
     * @param null $options
     *
     * @return TableCreate
     */
    public function tableCreate($tableName, $options = null)
    {
        return new TableCreate($this, $tableName, $options);
    }

    /**
     * @param $tableName
     *
     * @return TableDrop
     */
    public function tableDrop($tableName)
    {
        return new TableDrop($this, $tableName);
    }

    /**
     * @return TableList
     */
    public function tableList()
    {
        return new TableList($this);
    }

    /**
     * @param null $opts
     *
     * @return Wait
     */
    public function wait($opts = null)
    {
        return new Wait($this, $opts);
    }

    /**
     * @param null $opts
     *
     * @return Reconfigure
     */
    public function reconfigure($opts = null)
    {
        return new Reconfigure($this, $opts);
    }

    /**
     * @return Rebalance
     */
    public function rebalance()
    {
        return new Rebalance($this);
    }
}
