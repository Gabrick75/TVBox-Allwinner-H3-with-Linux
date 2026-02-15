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
## Alternativa para Cartão SD Lento (Boot no SD + Sistema no USB)

Caso seu cartão de memória seja muito lento e, ainda assim, você queira
utilizá-lo, existe a seguinte alternativa:

### Separar o boot do sistema

Boot no cartão SD e sistema instalado em pendrive ou HD externo.

HD externo mecânico **não é indicado**, pois a placa normalmente não
fornece amperagem suficiente para girar o disco. Isso pode causa queda
de tensão, afetando o funcionamento do processador e resultando em
travamento imediato do sistema.

Uma possível alternativa é alimentar o HD externo diretamente com 5V da
própria fonte da placa (utilizando a mesma fonte). Entretanto, existe
risco de danificar o HD e corromper dados.
(fiz e deu ruim.)

Dependendo do cenário, essa configuração pode resultar em melhor
desempenho.

Instale a distro escolhida em **ambos os dispositivos**. Você pode, por
exemplo:

-   Utilizar a versão minimal no cartão SD (U-Boot).
-   Utilizar a versão Desktop no HD externo.

------------------------------------------------------------------------

O que faremos é uma modificação que precisa ser realizada **pelo computador (não na TV
Box)**. O que vamos fazer é:

> "Inicie o processo normalmente, mas em vez de carregar o sistema que
> está no cartão SD, carregue o sistema que está no HD externo."

Abaixo está o passo a passo para realizar esse procedimento no seu
computador.

------------------------------------------------------------------------

## 1. Identificar os UUIDs (Identificadores Únicos)

1.  Conecte o **Cartão SD** e o **Pendrive/HD externo** ao seu PC.
2.  No terminal do PC, execute:

```bash
lsblk -f
```

3.  Anote o **UUID** da partição do HD externo (é um código semelhante a
    `a1b2c3d4-e5f6-...`).

Recomendo também anotar o UUID do cartão SD para referência futura,
caso seja necessário reverter a configuração.

------------------------------------------------------------------------

## 2. Configurar o Boot no Cartão SD

Agora vamos instruir o cartão SD a buscar o sistema no USB.

1.  Abra a partição do Cartão SD no gerenciador de arquivos do seu
    computador.
2.  Localize a pasta `/boot` ou verifique diretamente na raiz do cartão.
    Procure o arquivo **`armbianEnv.txt`** (caso utilize outra distro,
    procure o arquivo correspondente, como `xxxEnv.txt` (orangepiEnv.txt)).
3.  Abra esse arquivo com um editor de texto. Se necessário, utilize:

```bash
sudo nano /caminho/do/arquivo
```
   
4.  Localize a linha que começa com:

```bash
rootdev=UUID=...
```
    

Substitua o UUID existente pelo **UUID do HD externo** anotado
anteriormente.

5.  Verifique se existe a linha:

```bash
rootfstype=ext4
```
    

Caso não exista, adicione-a.

6.  Salve o arquivo e feche o editor.

------------------------------------------------------------------------

## 3. Ajustar o "Mapa" dentro do Pendrive/HD externo (FSTAB)

Se esse ajuste não for feito, o sistema poderá iniciar pelo HD externo,
mas continuará tentando gravar logs e arquivos temporários no cartão SD.

1.  Abra a partição do **HD externo** no seu PC.
2.  Acesse a pasta `/etc` e abra o arquivo **`fstab`**.
3.  Localize a linha que monta `/` (raiz do sistema). Verifique se o
    UUID informado corresponde ao **UUID do próprio HD externo**.
4.  Caso exista alguma linha apontando para o cartão SD ou montando
    `/boot` a partir dele, você pode adicionar um `#` no início da linha
    temporariamente para evitar conflitos.
5.  Salve e feche o arquivo.

(provavelmente estára tudo certo aqui e você não precisará fazer nada, mas é bom verificar.)
------------------------------------------------------------------------

## Como testar

1.  Coloque o HD externo e o cartão SD na TV Box.
2.  Ligue o equipamento.

### O que deve acontecer


O processador lê o cartão SD → O cartão SD lê o arquivo `armbianEnv.txt`
→ O arquivo manda o processador carregar o sistema que está no HD
externo.

---

Os scripts foram baseado no processo manual do vídeo:

https://www.youtube.com/watch?v=HaSdFQSUIho
