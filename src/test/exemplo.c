#include <avif/avif.h>
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Carregar arquivo AVIF para memória
    FILE *f = fopen("imagem.avif", "rb");
    if (!f) {
        perror("Erro ao abrir imagem.avif");
        return 1;
    }

    fseek(f, 0, SEEK_END);
    size_t fileSize = ftell(f);
    fseek(f, 0, SEEK_SET);

    uint8_t *avifData = malloc(fileSize);
    if (!avifData || fread(avifData, 1, fileSize, f) != fileSize) {
        perror("Erro ao ler imagem");
        fclose(f);
        free(avifData);
        return 1;
    }
    fclose(f);

    // Criar e usar o decoder
    avifDecoder *decoder = avifDecoderCreate();
    avifResult result = avifDecoderReadMemory(decoder, avifData, fileSize);
    if (result != AVIF_RESULT_OK) {
        fprintf(stderr, "Erro ao decodificar AVIF: %s\n", avifResultToString(result));
        avifDecoderDestroy(decoder);
        free(avifData);
        return 1;
    }

    // Obter imagem decodificada
    avifImage *image = decoder->image;

    // Converter para RGB
    avifRGBImage rgb;
    avifRGBImageSetDefaults(&rgb, image);
    rgb.format = AVIF_RGB_FORMAT_RGB;
    avifRGBImageAllocatePixels(&rgb);

    avifResult conv = avifImageYUVToRGB(image, &rgb);
    if (conv != AVIF_RESULT_OK) {
        fprintf(stderr, "Erro na conversão YUV->RGB: %s\n", avifResultToString(conv));
    } else {
        printf("Imagem decodificada com sucesso: %dx%d\n", rgb.width, rgb.height);
        // Aqui você pode usar rgb.pixels (buffer RGB intercalado)
    }

    // Limpeza
    avifRGBImageFreePixels(&rgb);
    avifDecoderDestroy(decoder);
    free(avifData);
    return 0;
}
