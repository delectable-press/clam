<?php

require_once 'vendor/autoload.php';

use WindowsAzure\Common\ServicesBuilder;
use WindowsAzure\Blob\Models\CreateContainerOptions;
use WindowsAzure\Blob\Models\PublicAccessType;
use WindowsAzure\Common\ServiceException;

class Storage {

    /**
     * @var WindowsAzure\Blob\Internal\IBlob
     */
    static $blobProxy;

    /**
     * @var CreateContainerOptions
     */
    static $blobOptions;

    /**
     * @var string
     */
    static $container;

    static function __constructor() {
        Storage::$blobProxy = ServicesBuilder::getInstance()->createBlobService(getenv('AZURE_STORAGE_CONNECTION_STRING'));
        Storage::$blobOptions = new CreateContainerOptions();
        Storage::$blobOptions->setPublicAccess(PublicAccessType::BLOBS_ONLY);

        Storage::$container = getenv("AZURE_CONTAINER_NAME");

        try {
            Storage::$blobProxy->createContainer(Storage::$container, Storage::$blobOptions);
        }
        catch (ServiceException $ex) {
            // todo: proper error handling needed?
        }
    }

    static function copy($source, $dest, $context = null) {
        Storage::$blobProxy->copyBlob(Storage::$container, $dest, Storage::$container, $source);
    }

    static function unlink($filename, $context = null) {
        Storage::$blobProxy->deleteBlob(Storage::$container, $filename);
    }

    static function chgrp($filename, $group) {
        return true;
    }

    static function chmod($filename, $mode) {
        return true;
    }

    static function chown($filename, $user) {
        return true;
    }
}

try {
    $storage->blobProxy =
}
