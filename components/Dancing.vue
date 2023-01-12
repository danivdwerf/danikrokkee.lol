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

let model: THREE.Group;
let sound: THREE.Audio;
let scene: THREE.Scene;
let camera: THREE.Camera;
let mixer: THREE.AnimationMixer;
let renderer: THREE.WebGLRenderer;
let animation: THREE.AnimationAction;

const clock: THREE.Clock = new THREE.Clock();
const fbxLoader: FBXLoader = new FBXLoader();
const textureLoader = new THREE.TextureLoader();

const stage: Ref<HTMLDivElement | undefined> = ref();

const mounted = async(): Promise<void>=>
{
    if (!stage.value)
        return;

    setupScene();
    createLights();

    try{await Promise.all([placeFloor(), createAudio(), placeModel()]);}
    catch(error){return console.error(error)}

    $emit("loaded");
};

const setupScene = (): void=>
{
    if (!stage.value)
        return;
    
    // renderer
    renderer = new THREE.WebGLRenderer();
    renderer.shadowMap.enabled = true;
    renderer.shadowMap.type = THREE.PCFSoftShadowMap;
    renderer.setSize(stage.value.clientWidth, stage.value.clientHeight);
    stage.value.appendChild(renderer.domElement);

    // scene
    scene = new THREE.Scene();

    // camera
    camera = new THREE.PerspectiveCamera(75, stage.value.clientWidth / stage.value.clientHeight, 0.1, 1000);
    camera.position.set(0, 3, 6);

    window.addEventListener("resize", ()=>
    {
        if (!stage.value)
            return;

        camera.aspect = stage.value.clientWidth / stage.value.clientHeight;
        renderer.setSize(stage.value.clientWidth, stage.value.clientHeight);
    });
};

const createLights = (): void=>
{
    const spotLight = new THREE.SpotLight(0xFFFFFF, 4);
    spotLight.position.set(0, 40, 30);
    spotLight.angle = Math.PI / 35;
    spotLight.penumbra = 0.5;
    spotLight.decay = 2;
    spotLight.distance = 100;

    spotLight.castShadow = true;
    spotLight.shadow.mapSize.width = 1024;
    spotLight.shadow.mapSize.height = 1024;
    spotLight.shadow.camera.near = 10;
    spotLight.shadow.camera.far = 200;
    spotLight.shadow.focus = 1;
    scene.add(spotLight);
};

const placeFloor = async(): Promise<void>=>
{
    const material = new THREE.MeshPhongMaterial({
        map: textureLoader.load("/models/floor/textures/albedo.jpg"),
    });

    const floorObj = await fbxLoader.loadAsync("models/floor/floor.fbx");

    // Apply material to children
    floorObj.traverse(child=>
    {
        if (!(child instanceof THREE.Mesh))
            return;

        // apply texture
        child.material = material;
        child.material.needsUpdate = true;

        child.castShadow = true;
        child.receiveShadow = true;
    });

    floorObj.position.set(-2, 0, -6);
    floorObj.scale.set(0.1, 0.1, 0.1);
    scene.add(floorObj);
};

const createAudio = async(): Promise<void>=>
{
    // create an AudioListener and add it to the camera
    const listener = new THREE.AudioListener();
    camera?.add(listener);

    // load a sound
    const audioLoader = new THREE.AudioLoader();
    const buffer = await audioLoader.loadAsync("audio/song.mp3");

    // create a global audio source
    sound = new THREE.Audio(listener);
    sound.setLoop(true);
    sound.autoplay = false;
    sound.setBuffer(buffer);
}

const placeModel = async(): Promise<void>=>
{
    model = await fbxLoader.loadAsync("models/model.fbx", onFBXProgress);
    model.scale.set(0.03, 0.03, 0.03);

    // Apply material to children
    model.traverse(child=>
    {
        if (!(child instanceof THREE.Mesh))
            return;

        child.castShadow = true;
    });

    mixer = new THREE.AnimationMixer(model)
    animation = mixer.clipAction(model.animations[0])

    scene?.add(model);
};


const onFBXProgress = (event: ProgressEvent<EventTarget>): void=>
    $emit("progress", event.loaded / event.total * 100);

const play = (): void=>
{
    animation?.play();
    sound?.play();
    tick();
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

onMounted(mounted);
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