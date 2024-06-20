import Product from "./Product.js";
import { formatPrice } from "./helpers.js";

export default class Cart{
    constructor(){
        if(localStorage.getItem("shopping-cart")){
            this.products = this.getProductsStorage();
        }else{
            this.products = [];
        }
    }

    addProduct(product){
        const elementId = parseInt(product.id);
        const index = this.getIndexProduct(elementId);
        if(index >= 0){
            this.products[index].qty += 1;
        }else{
            this.products.push(product);
        }

        localStorage.setItem("shopping-cart", this.getJson());

        return this.products;
    }

    getJson(){
        return JSON.stringify(this.products);
    }

    getProductsStorage(){
        return JSON.parse(localStorage.getItem("shopping-cart"));
    }

    getTotalProducts(){
        if(this.products.length > 0){
            return this.products.reduce((acc, element) => acc + element.qty, 0);
        }

        return 0;
    }

    getIndexProduct(id){
        return this.products.findIndex(el => el.id === id);
    }

    getTotalPricesList(){
        const sumPrices = this.products.reduce((acc, element) => acc + element.price * element.qty, 0);
        return formatPrice(sumPrices);
    }

    updateProduct(productId, action){
        const index = this.getIndexProduct(productId);
        if(action == 'add'){
            this.products[index].qty += 1;
        }else{
            if(this.products[index].qty == 1){
                this.removeProduct(index);
            }else{
                this.products[index].qty -= 1;
            }
        }

        localStorage.setItem("shopping-cart", this.getJson());

        return this.products;
    }

    removeProduct(index){
        const products = this.products.splice(index, 1);
        localStorage.setItem("shopping-cart", this.getJson());

        return this.products;
    }

}