# TV Box com Linux (Allwinner H3)

🇺🇸 Read in English: [README.md](README.md)

------------------------------------------------------------------------

## Sobre o Projeto

Neste repositório documento como transformei uma TV Box Allwinner H3 em
um ambiente Linux funcional.

Não altera a NAND interna.\
Removendo o SD, volta ao sistema original.

------------------------------------------------------------------------

## Hardware

-   CPU: 4× ARM Cortex-A7 @ 1008 MHz\
-   GPU: Mali-400 MP\
-   RAM: 1 GiB\
-   Armazenamento interno: 8 GB NAND

Chipset: Allwinner H3 (sun8iw7p1)

Mais informações:\
https://linux-sunxi.org/H3

------------------------------------------------------------------------

## Teste de Velocidade do Cartão

``` bash
cd yoursdcard/
dd if=/dev/zero of=teste_escrita bs=1M count=100 conv=fdatasync
```

Mínimo recomendado: **12MB/s**

------------------------------------------------------------------------

## ISOs Compatíveis

  | ISO | Kernel | Status |
|-----|--------|--------|
| https://www.retrorangepi.org/images/Sunvell-r69/ | X | Retro build |
| https://www.armbian.com/orange-pi-pc/ | 6.12.68 | Works (reduced performance) |
| Orangepipc_2.0.8_debian_buster_server_linux5.4.65.7z | 5.4.65 | Recommended |
| Orangepipc_2.0.8_debian_buster_desktop_linux5.4.65.7z | 5.4.65 | Recommended |
| OrangePi_pc_debian_stretch_server_linux3.4.113_v1.0.tar.gz | 3.4.113 | Legacy |
| OrangePi_pc_debian_stretch_desktop_linux3.4.113_v1.0.tar.gz | 3.4.113 | Legacy |


## Galeria de Imagens
<table>
  <tr>
    <td><img src="images/image1.webp" alt="Screenshot 1"></td>
    <td><img src="images/image2.webp" alt="Screenshot 2"></td>
  </tr>
  <tr>
    <td><img src="images/image3.webp" alt="Screenshot 3"></td>
    <td><img src="images/image4.webp" alt="Screenshot 4"></td>
  </tr>
  <tr>
    <td><img src="images/image5.webp" alt="Screenshot 5"></td>
    <td><img src="images/image6.webp" alt="Screenshot 6"></td>
  </tr>
</table>


## Estrutura

    Estrutura
    ├── README.md
    ├── README-pt.md
    ├── scripts/
    │   ├── script1.sh
    │   └── script2.sh
    |── images/

------------------------------------------------------------------------

Baseado no vídeo:

https://www.youtube.com/watch?v=HaSdFQSUIho
