<template>
    <div id="page">
        <div id="header">
            <h1>Dani Krokkee</h1>
        </div>

        <div v-if="!isPlaying" id="loader">
            <h1 v-if="loading">Dani Krokkee is being loaded...</h1>
            <h1 v-else>Your experience is ready to be started</h1>

            <loader v-if="loading" id="spinner" />
            <button v-else @click="play">
                <p>Start</p>
            </button>
        </div>

        <dancing ref="dancing" @loaded="loading = false" @progress="onProgress" />
    </div>
</template>

<script lang="ts" setup>
import {ref} from "vue";

import type {Ref} from "vue";

import Dancing from "@/components/Dancing.vue";

const dancing: Ref<typeof Dancing | undefined> = ref();
const progress: Ref<number> = ref(0);
const isPlaying: Ref<boolean> = ref(false);
const loading: Ref<boolean> = ref(true);

const play = (): void=>
{
    isPlaying.value = true;
    dancing.value?.play();
};

const onProgress = (value: number): void=>
{
    progress.value = Math.ceil(value);
}
</script>

<style lang="scss" scoped>
#header
{
    top: 0px;
    left: 0px;
    right: 0px;
    z-index: 1;
    padding: 1rem;
    position: fixed;
    color: #FFFFFF;
}

#loader
{
    top: 0px;
    left: 0px;
    z-index: 2;
    right: 0px;
    bottom: 0px;
    padding: 0.8rem;
    display: flex;
    position: fixed;
    align-items: center;
    flex-direction: column;
    justify-content: center;
    background-color: #EDEDED;

    h1
    {
        text-align: center;
    }

    button
    {
        margin-top: 2rem;
        border-radius: 1rem;
        padding: 0.6rem 1.5rem;
        background-color: #3549BA;

        p
        {
            font-weight: 900;
            font-size: 1.5rem;
            color: #FFFFFF;
        }
    }
}

#spinner
{
    width: 35vh
}
</style>