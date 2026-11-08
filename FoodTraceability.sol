
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FoodTraceability {

    // Stores information about each food product
    struct Product {
        uint256 id;
        string name;
        string origin;
        address currentOwner;
        string status;
        uint256 registeredAt;
    }

    // Stores a record of each product movement
    struct TransferRecord {
        address sender;
        address receiver;
        string status;
        uint256 timestamp;
    }

    // Product ID => Product information
    mapping(uint256 => Product) private products;

    // Product ID => Product history
    mapping(uint256 => TransferRecord[]) private histories;

    // Checks  the products is registerd or not 
    mapping(uint256 => bool) public productExists;

    // Events that provides  evidence of blockchain actions
    event ProductRegistered(
        uint256 indexed productId,
        address indexed owner
    );

    event ProductTransferred(
        uint256 indexed productId,
        address indexed sender,
        address indexed receiver
    );

    event ProductStatusUpdated(
        uint256 indexed productId,
        string newStatus
    );

    // 1. Registering  a new food product
    function registerProduct(
        uint256 _id,
        string memory _name,
        string memory _origin,
        string memory _status
    ) public {
        require(_id > 0, "Invalid product ID");
        require(!productExists[_id], "Product already exists");
        require(bytes(_name).length > 0, "Name is required");
        require(bytes(_origin).length > 0, "Origin is required");
        require(bytes(_status).length > 0, "Status is required");

        products[_id] = Product(
            _id,
            _name,
            _origin,
            msg.sender,
            _status,
            block.timestamp
        );

        productExists[_id] = true;

        histories[_id].push(
            TransferRecord(
                address(0),
                msg.sender,
                _status,
                block.timestamp
            )
        );

        emit ProductRegistered(_id, msg.sender);
    }

    // 2. Transfer a product to another blockchain account
    function transferProduct(
        uint256 _id,
        address _receiver
    ) public {
        require(productExists[_id], "Product does not exist");

        Product storage product = products[_id];

        require(
            msg.sender == product.currentOwner,
            "Only current owner can transfer"
        );

        require(
            _receiver != address(0),
            "Invalid receiver address"
        );

        require(
            _receiver != msg.sender,
            "Cannot transfer to yourself"
        );

        address previousOwner = product.currentOwner;

        product.currentOwner = _receiver;
        product.status = "Transferred";

        histories[_id].push(
            TransferRecord(
                previousOwner,
                _receiver,
                "Transferred",
                block.timestamp
            )
        );

        emit ProductTransferred(
            _id,
            previousOwner,
            _receiver
        );
    }

    // 3. Update the current status of a product
    function updateProductStatus(
        uint256 _id,
        string memory _newStatus
    ) public {
        require(productExists[_id], "Product does not exist");

        require(
            msg.sender == products[_id].currentOwner,
            "Only current owner can update status"
        );

        require(
            bytes(_newStatus).length > 0,
            "Status is required"
        );

        products[_id].status = _newStatus;

        emit ProductStatusUpdated(_id, _newStatus);
    }

    // 4. View product information
    function getProduct(
        uint256 _id
    ) public view returns (Product memory) {
        require(productExists[_id], "Product does not exist");

        return products[_id];
    }

    // 5. View complete registration and transfer history
    function getProductHistory(
        uint256 _id
    ) public view returns (TransferRecord[] memory) {
        require(productExists[_id], "Product does not exist");

        return histories[_id];
    }
}
