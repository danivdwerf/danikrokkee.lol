<template>
    <div ref="stage" id="stage" />
</template>

<script lang="ts" setup>
import {ref, onMounted, defineEmits, defineExpose} from "vue";

import * as THREE from "three";
import {FBXLoader} from "three/examples/jsm/loaders/FBXLoader";

import type {Ref} from "vue";

const $emit = defineEmits<{
    (e: "progress", progress: number): void,
    (e: "loaded"): void
}>();

const stage: Ref<HTMLDivElement | undefined> = ref();

let model: THREE.Group;
let sound: THREE.Audio;
let scene: THREE.Scene;
let camera: THREE.Camera;
let mixer: THREE.AnimationMixer;
let renderer: THREE.WebGLRenderer;
let animation: THREE.AnimationAction;
const clock: THREE.Clock = new THREE.Clock();

onMounted(()=>
{
    if (!stage.value)
        return;
    
    // Create renderer
    renderer = new THREE.WebGLRenderer();
    renderer.setSize(stage.value.clientWidth, stage.value.clientHeight);
    stage.value.appendChild(renderer.domElement);

    // Create scene
    scene = new THREE.Scene();

    // Create camera
    camera = new THREE.PerspectiveCamera(75, stage.value.clientWidth / stage.value.clientHeight, 0.1, 1000);
    camera.position.set(0, 3, 6);

    // Light
    const light = new THREE.PointLight()
    light.position.set(2.5, 7.5, 15)
    scene.add(light);

    createAudio();
    loadFBX();

    tick();
});

const createAudio = (): void=>
{
    // create an AudioListener and add it to the camera
    const listener = new THREE.AudioListener();
    camera?.add(listener);

    // create a global audio source
    sound = new THREE.Audio(listener);
    sound.setLoop(true);
    sound.autoplay = false;

    // load a sound and set it as the Audio object's buffer
    const audioLoader = new THREE.AudioLoader();
    audioLoader.load("audio/song.mp3", onAudioLoaded);
}

const onAudioLoaded = (buffer: AudioBuffer)=>
{
    sound?.setBuffer(buffer);
}

const loadFBX = (): void=>
{
    const fbxLoader: FBXLoader = new FBXLoader();
    fbxLoader.load("models/model.fbx", onFBXLoaded, onFBXProgress);
}

const onFBXProgress = (event: ProgressEvent<EventTarget>): void=>
{
    $emit("progress", event.loaded / event.total * 100);
}

const onFBXLoaded = (object: THREE.Group): void=>
{
    object.scale.set(0.03, 0.03, 0.03);
    model = object;
    mixer = new THREE.AnimationMixer(object)
    animation = mixer.clipAction(object.animations[0])
    scene?.add(object);
    $emit("loaded");
}

const play = (): void=>
{
    animation?.play();
    sound?.play();
}

const tick = (): void=>
{
    requestAnimationFrame(tick);

    if (!scene || !camera)
        return;
    
    renderer?.render(scene, camera);
    mixer?.update(clock.getDelta())
    model?.rotateY(0.01);
}

defineExpose({play});
</script>

<style lang="scss" scoped>
#stage
{
    width: 100vw;
    height: 100vh;
    background-color: #000000;
}
</style>