// src/createGif.cpp
#define STB_IMAGE_IMPLEMENTATION
#define STB_IMAGE_RESIZE_IMPLEMENTATION
#define STBI_NO_HDR

#include <Rcpp.h>
#include "gif.h"
#include "stb_image.h"
#include "stb_image_resize2.h"
#include <vector>
#include <string>
#include <iostream>
#include <fstream>

using namespace Rcpp;

// [[Rcpp::export]]
RawVector createGifRcpp(const std::vector<std::string>& image_paths, bool debug = false) {
    if (image_paths.empty()) {
        if (debug) Rcout << "No images provided." << std::endl;
        stop("No images provided.");
    }

    int width = 0, height = 0, channels = 0;

    // Load the first image to get dimensions, as we suppose all images have the same dimensions...
    // TODO - Do a better check for this
    if (debug) Rcout << "Loading first image to get dimensions..." << std::endl;
    unsigned char* first_image = stbi_load(image_paths[0].c_str(), &width, &height, &channels, 4);
    if (!first_image) {
        if (debug) Rcout << "Failed to load image: " << image_paths[0] << std::endl;
        stop("Failed to load the first image.");
    }
    stbi_image_free(first_image);
    if (debug) Rcout << "First image loaded successfully. Dimensions: " << width << "x" << height << std::endl;

    std::string temp_filename = std::tmpnam(nullptr);
    GifWriter gif;

    if (!GifBegin(&gif, temp_filename.c_str(), width, height, 100)) {
        stop("Failed to initialize GIF.");
    }

    for (const auto& image_path : image_paths) {
        if (debug) Rcout << "Processing image: " << image_path << std::endl;

        int img_width = 0, img_height = 0, img_channels = 0;
        unsigned char* image_data = stbi_load(image_path.c_str(), &img_width, &img_height, &img_channels, 4);
        if (!image_data) {
            if (debug) Rcout << "Failed to load image: " << image_path << std::endl;
            GifEnd(&gif);
            stop("Failed to load image.");
        }

        if (debug) Rcout << "Image loaded successfully. Dimensions: " << img_width << "x" << img_height << std::endl;
        std::vector<uint8_t> resized_image(width * height * 4);
        stbir_resize_uint8_linear(image_data, img_width, img_height, 0, resized_image.data(), width, height, 0, (stbir_pixel_layout)4);
        GifWriteFrame(&gif, resized_image.data(), width, height, 100);

        stbi_image_free(image_data);
    }

    GifEnd(&gif);

    std::ifstream gif_file(temp_filename, std::ios::binary);
    std::vector<uint8_t> gif_data((std::istreambuf_iterator<char>(gif_file)), std::istreambuf_iterator<char>());
    gif_file.close();
    std::remove(temp_filename.c_str());

    if (debug) Rcout << "GIF created successfully." << std::endl;
    return RawVector(gif_data.begin(), gif_data.end());
}
