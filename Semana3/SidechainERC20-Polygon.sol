// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Interfaz del contrato ERC20 para Ethereum
interface IERC20Ethereum {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}

// Interfaz del contrato ERC20 para Polygon (Matic)
interface IERC20Polygon {
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract DepositoInteroperable {
    address public direccionTokenEthereum; // Dirección del contrato del token ERC20 en Ethereum
    address public direccionTokenPolygon; // Dirección del contrato del token ERC20 en Polygon (Matic)

    // Evento para registrar un depósito realizado
    event DepositoRealizado(address remitente, uint256 cantidadEthereum, uint256 cantidadPolygon);

    // Constructor que recibe las direcciones de los contratos de tokens
    constructor(address _direccionTokenEthereum, address _direccionTokenPolygon) {
        direccionTokenEthereum = _direccionTokenEthereum;
        direccionTokenPolygon = _direccionTokenPolygon;
    }

    // Función para realizar un depósito de tokens ERC20 en Ethereum y recibir tokens equivalentes en Polygon
    function depositarTokens(uint256 cantidadEthereum) external {
        // Transferir tokens ERC20 desde la cuenta del remitente al contrato en Ethereum
        require(IERC20Ethereum(direccionTokenEthereum).transferFrom(msg.sender, address(this), cantidadEthereum), "Transferencia ERC20 fallida");

        // Emitir evento de depósito realizado
        emit DepositoRealizado(msg.sender, cantidadEthereum, cantidadEthereum);

        // Transferir tokens equivalentes en Polygon a la cuenta del remitente
        require(IERC20Polygon(direccionTokenPolygon).transfer(msg.sender, cantidadEthereum), "Transferencia en Polygon fallida");
    }
}
