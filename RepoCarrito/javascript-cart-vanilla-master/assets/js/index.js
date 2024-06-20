import Cart from './Cart.js';
import Product from './Product.js';
import {formatPrice} from './helpers.js';

const d = document,
    w = window,
    $shoppingCart = d.querySelector('.shopping-cart');

const cart = new Cart();

const UICartProducts = () => {
    const $productsCart = d.getElementById('products-cart');
    const $totalPrices = d.querySelector('.total-cart-checkout .total');
    if(cart.getTotalProducts() == 0){
        $productsCart.innerHTML = `<h4>No hay productos agregados.</h4>`;
    }else{
        const products = cart.getProductsStorage();

        const $fragment = d.createDocumentFragment();

        $productsCart.innerHTML = '';

        products.forEach((product) => {
            const $itemRow = d.createElement('div');

            $itemRow.classList.add('item-row');
            $itemRow.dataset.id = product.id;
            
            $itemRow.innerHTML = `
            <div class="picture">
                <img src="${product.image}">
            </div>

            <div class="info-actions">
                <div class="name">${product.name}</div>
                <div class="price">$${formatPrice(product.price)}</div>

                <div class="box-qty">
                    <button type="button" class="remove-qty">-</button>
                    <span class="qty">${product.qty}</span>
                    <button type="button" class="add-qty">+</button>
                </div>
            </div>
            `;

            $fragment.appendChild($itemRow);

        })

        $productsCart.appendChild($fragment);
    }

    $totalPrices.textContent = `Total: $${cart.getTotalPricesList()}`;
    getTotalCartItems();
}

const openCart = () => {
    $shoppingCart.classList.add('open-cart');
    UICartProducts();
}

const closeCart = () => {
    $shoppingCart.classList.remove('open-cart');
}

const getTotalCartItems = () => {
    const $cartQuantity = d.querySelector('.qty-cart');
    $cartQuantity.textContent = cart.getTotalProducts();
}

const addProductToCart = (element) => {

    const $item = element.target.parentElement;

    const newProduct = new Product(
        parseInt($item.querySelector('.add-to-cart').dataset.id),
        $item.querySelector('.name').textContent,
        parseInt($item.querySelector('.price').textContent.replace('$', '').replace('.', '')),
        $item.querySelector('.picture img').getAttribute('src'),
        1
    );

    cart.addProduct(newProduct);
    openCart();
}

d.addEventListener("DOMContentLoaded", (e) => {
    UICartProducts();
});

/***** Bubble Events *****/
d.addEventListener("click", (e) => {

    if (e.target.matches(".add-to-cart")) {
        addProductToCart(e);
    }

    if ($shoppingCart.classList.contains('open-cart') && !e.target.matches('.add-to-cart')) {
        closeCart();
    }

    if(e.target.matches("#button-cart") || e.target.matches("#button-cart *")){
        openCart();
    }

});
/*! **** END Bubble Events *****/

/***** Capture Events *****/
d.addEventListener('click', (e) => {
    if(e.target.matches(".add-qty")){
        const productId = parseInt(e.target.parentElement.parentElement.parentElement.dataset.id);
        cart.updateProduct(productId, 'add');
        UICartProducts();
    }

    if(e.target.matches(".remove-qty")){
        const productId = parseInt(e.target.parentElement.parentElement.parentElement.dataset.id);
        cart.updateProduct(productId, 'remove');
        UICartProducts();
    }

}, true);
/*! **** END Capture Events *****/

$shoppingCart.addEventListener('click', (e) => {
    e.stopPropagation();
});
