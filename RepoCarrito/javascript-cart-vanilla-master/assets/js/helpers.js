const formatPrice = (number) => {
    const formatted = new Intl.NumberFormat('es-CH').format(number);
    return `${formatted}`;
}

export {
    formatPrice
};