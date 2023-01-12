<template>
    <div class="spinner">
        <div v-for="i in 16" :key="`circle-${i}`" class="circle" />
    </div>
</template>

<style lang="scss" scoped>
.spinner
{
    display: block;
    aspect-ratio: 1;
    position: relative;
    transform-style: preserve-3d;
    transform: perspective(1000px) rotateY(45deg) rotateX(45deg);
}

.circle
{
    top: 50%;
    left: 50%;
    aspect-ratio: 1;
    position: absolute;
    border-radius: 50%;
    animation-name: spin;
    background: transparent;
    border: 2px solid #222222;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    transform: translate3d(-50%, -50%, 0);

    &:nth-child(0)
    {
        top: 0;
        left: 0;
        width: 100%;
        animation: spin Infinitys infinite linear;
    }

    &:nth-child(1)
    {
        // top: 2.1875vh;
        // left: 2.1875vh;
        width: 93.75%;
        animation-duration: 12000ms;
    }

    &:nth-child(2)
    {
        // left: 4.375vh;
        // top: 4.375vh;
        width: 87.5%;
        animation-duration: 6000ms;
    }

    &:nth-child(3)
    {
        // left: 6.5625vh;
        // top: 6.5625vh;
        width: 81.25%;
        animation-duration: 4000ms;
    }

    &:nth-child(4)
    {
        // left: 8.75vh;
        // top: 8.75vh;
        width: 75%;
        animation-duration: 3000ms;
    }

    &:nth-child(5)
    {
        // left: 10.9375vh;
        // top: 10.9375vh;
        width: 68.75%;
        animation-duration: 2400ms;
    }

    &:nth-child(6)
    {
        // left: 13.125vh;
        // top: 13.125vh;
        width: 62.5%;
        animation-duration: 2000ms;
    }

    &:nth-child(7)
    {
        // left: 15.3125vh;
        // top: 15.3125vh;
        width: 56.25%;
        animation-duration: 1714.285714285714ms;
    }

    &:nth-child(8)
    {
        // left: 17.5vh;
        // top: 17.5vh;
        width: 50%;
        animation-duration: 1500ms;
    }

    &:nth-child(9)
    {
        // left: 19.6875vh;
        // top: 19.6875vh;
        width: 62.5%;
        animation-duration: 1333.333333333333ms;
    }

    &:nth-child(10)
    {
        // left: 21.875vh;
        // top: 21.875vh;
        width: 37.5%;
        animation-duration: 1200ms;
    }

    &:nth-child(11)
    {
        // left: 24.0625vh;
        // top: 24.0625vh;
        width: 31.25%;
        animation-duration: 1090.909090909091ms;
    }

    &:nth-child(12)
    {
        // left: 26.25vh;
        // top: 26.25vh;
        width: 25%;
        animation-duration: 1000ms;
    }

    &:nth-child(13)
    {
        // left: 28.4375vh;
        // top: 28.4375vh;
        width: 18.75%;
        animation-duration: 923.076923076923ms;
    }

    &:nth-child(14)
    {
        // left: 30.625vh;
        // top: 30.625vh;
        width: 12.5%;
        animation-duration: 857.142857142857ms;
    }

    &:nth-child(15)
    {
        // left: 32.8125vh;
        // top: 32.8125vh;
        width: 6.25%;
        animation-duration: 800ms;
    }

    &:nth-child(16)
    {
        // left: 35vh;
        // top: 35vh;
        width: 0;
        animation-duration: 750ms;
    }

    &:nth-child(2n){border: 2px dashed rgba(#222222, 0.5)}
}

@keyframes spin
{
    0%{transform: translate3d(-50%, -50%, 0) rotateX(0deg)}
    100%{transform: translate3d(-50%, -50%, 0) rotateX(360deg)}
}
</style>