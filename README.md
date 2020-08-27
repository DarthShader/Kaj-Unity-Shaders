# Kaj-Unity-Shaders

This is a collection of VRChat-centric Unity shaders and shader utilities.  Documentation in progress.

# [Downloads (.unitypackage)](https://github.com/DarthShader/Kaj-Unity-Shaders/releases)

## Kaj Shader Editor
Procedural inspector that serves as a functionally complete foundation for all shaders; meant to build upon the default material inspector to reach all possible material/shader settings without shader-specific logic.

## Kaj Shader Optimizer
Preprocessor that generates a new shader for a specific material, assuming most/all of its properties are constant.  Mega shaders can now be made efficient without having to use `shader_feature` and `multi_compile` keywords.

## PBR Shader
Modular Physically Based Rendering mega shader that aims to provide the features Unity's HDRP Lit shader provides (and beyond), but on the standard rendering pipeline.  Forward/Shader Model 5.0 only.

## Nothing Shader
A small utility shader/material with no passes, thanks to disabled LightModes.  Perfect for material swapping on meshes without adding draw calls.
