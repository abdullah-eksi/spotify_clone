# Spoclon - Müzik Akış Uygulaması

Spoclon, Flutter kullanılarak geliştirilen modern bir müzik akış uygulamasıdır. Spotify'a benzer bir kullanıcı deneyimi sunar Proje Geliştirmeye Devam Ediliyor Flutter Öğrenme Sürecimde Geliştirdim bir Proje Temiz Kod Yazamadıysam Kusura Bakmayınız Proje İlerleyen Dönemde Güncelleme Alacaktır.
## Özellikler

- **Müzik Çalma**: Şarkıları doğrudan uygulama içinden çalma, duraklatma, ileri/geri sarma.
- **Tek Tıklama Kontrolü**: İyileştirilmiş kullanıcı deneyimi için tek tıklama ile oynatma/duraklatma.
- **Mini Oynatıcı**: Uygulama içinde gezinirken şarkıyı dinlemeye devam etme imkanı.
- **Sanatçı Sayfaları**: Sanatçı bilgileri, popüler şarkıları ve benzer sanatçıları görüntüleme.
- **Çalma Listeleri**: Özel çalma listeleri oluşturma ve düzenleme.
- **Albüm Görünümü**: Albüm içeriklerini görüntüleme ve dinleme.
- **Favoriler**: Şarkıları, sanatçıları ve çalma listelerini favori olarak işaretleme.
- **Arama**: Tüm içerik türlerinde arama yapma.

## Kurulum

1. Flutter'ı bilgisayarınıza yükleyin. [Flutter Kurulum](https://flutter.dev/docs/get-started/install)
2. Projeyi klonlayın veya indirin.
3. Bağımlılıkları yükleyin:
   ```
   flutter pub get
   ```
4. Uygulamayı çalıştırın:
   ```
   flutter run
   ```

## Proje Yapısı

```
lib/
  ├── main.dart          # Uygulama başlangıç noktası
  ├── model/             # Veri modelleri
  │    ├── song.dart     # Şarkı modeli ve veri yapısı
  │    ├── artist.dart   # Sanatçı modeli ve veri yapısı
  │    ├── album.dart    # Albüm modeli ve veri yapısı
  │    ├── playlist.dart # Çalma listesi modeli ve veri yapısı
  │    └── category.dart # Kategori modeli ve veri yapısı
  ├── service/           # Servis sınıfları
  │    ├── player_service.dart     # Müzik çalma servisi ve durum yönetimi
  │    ├── api_service.dart        # API iletişimi ve veri çekme
  │    ├── favorite_service.dart   # Favori yönetimi ve depolama
  │    ├── mock_song_service.dart  # Demo veriler ve test içeriği
  │    ├── playlist_manager.dart   # Çalma listesi yönetimi ve sıralama
  │    └── sort_service.dart       # İçerik sıralama ve filtreleme
  └── view/              # Kullanıcı arayüzü
       ├── component/    # Yeniden kullanılabilir bileşenler
       │    ├── common/  # Genel kullanım bileşenleri (butonlar, kartlar vb.)
       │    ├── player/  # Oynatıcı bileşenleri
       │    │    ├── mini_player.dart  # Küçük oynatıcı bileşeni
       │    │    ├── player_controls.dart  # Oynatıcı kontrolleri
       │    │    └── progress_bar.dart  # İlerleme çubuğu
       │    ├── playlist/  # Çalma listesi bileşenleri
       │    └── artist/   # Sanatçı bileşenleri
       └── pages/        # Ana sayfalar
            ├── home_page.dart     # Ana sayfa
            ├── search_page.dart   # Arama sayfası
            ├── library_page.dart  # Kütüphane sayfası
            ├── player_page.dart   # Tam ekran oynatıcı sayfası
            ├── artist_detail_page.dart  # Sanatçı detay sayfası
            ├── album_page.dart    # Albüm detay sayfası
            ├── playlist_detail_page.dart  # Çalma listesi detay sayfası
            ├── create_playlist_page.dart  # Çalma listesi oluşturma sayfası
            └── process/    # Sayfa işlem mantığı (Process)
                 ├── home_process.dart    # Ana sayfa veri yönetimi
                 ├── player_process.dart  # Oynatıcı işlem mantığı
                 ├── search_process.dart  # Arama işlem mantığı
                 ├── library_process.dart # Kütüphane işlem mantığı
                 └── artist_process.dart  # Sanatçı sayfası işlem mantığı
```

## Process Dosyaları Açıklaması

Process dosyaları, sayfa görünümlerinden iş mantığını ayırmak için tasarlanmıştır. Bu dosyalar, kullanıcı arayüzü ve veri/iş mantığı arasında bir köprü görevi görür:

- **home_process.dart**: Ana sayfa için veri yükleme, kategori filtreleme ve öne çıkan içerikleri yönetir. Önerilen çalma listeleri, yeni çıkan albümler ve popüler sanatçıları getirir.

- **player_process.dart**: Oynatıcı sayfasının iş mantığını yönetir. Şarkı geçişleri, oynatma kontrolü, ilerleme çubuğu güncelleme ve ses seviyesi kontrolü gibi işlemleri gerçekleştirir. Ayrıca tekrarlama ve karıştırma modları için mantık sağlar.

- **search_process.dart**: Arama işlemlerini yönetir. Arama sorguları için farklı içerik türlerinde (şarkılar, sanatçılar, albümler, çalma listeleri) sonuçları filtreleme ve sıralama işlemlerini gerçekleştirir.

- **library_process.dart**: Kullanıcı kütüphanesi ile ilgili işlemleri yönetir. Kaydedilen çalma listeleri, beğenilen şarkılar, takip edilen sanatçılar ve indirilen içeriklerin görüntülenmesi ve yönetimi.

- **artist_process.dart**: Sanatçı sayfasındaki veri yönetimini sağlar. Sanatçı bilgilerini, popüler şarkılarını, albümlerini ve benzer sanatçıları getirir. Ayrıca sanatçı takip etme işlemlerini yönetir.

## Mimari Tasarım

Spoclon, temiz kod prensiplerini takip eden modüler bir mimari kullanır:

1. **MVC+ Mimari**: Model-View-Controller yapısına ek olarak Process ve Service katmanları eklenmiştir.
   - **Model**: Veri yapılarını ve temel işlemleri tanımlar
   - **View**: Kullanıcı arayüzü bileşenlerini içerir
   - **Process**: Sayfalar için iş mantığını yönetir
   - **Service**: Global veri ve durum yönetimi sağlar

2. **Bağımlılık Enjeksiyonu**: Servisler singleton pattern ile uygulanmıştır, bu da test edilebilirliği artırır.

3. **State Management**: ChangeNotifier pattern kullanarak etkin durum yönetimi sağlanmıştır.

## Özelleştirme

Uygulama temaları ve davranışları şu parametrelerle özelleştirilebilir:

- **Tema Ayarları**: `main.dart` içinde yer alan ThemeData sınıfını düzenleyerek.
- **İçerik Kaynağı**: API servisini gerçek bir backend'e bağlayarak veya mock servisleri özelleştirerek.
- **Dil Ayarları**: Tüm metinler Türkçe olarak ayarlanmıştır, farklı diller için çeviriler eklenebilir.

## Geliştirme Yönergeleri

Yeni özellikler eklerken veya mevcut kodu değiştirirken aşağıdaki kurallara uyulmalıdır:

1. Tüm yorumlar ve kod açıklamaları Türkçe olmalıdır.
2. Yeni servisler `service` klasöründe tanımlanmalıdır.
3. Sayfa iş mantığı `process` dosyalarında olmalı, UI bileşenleri bu dosyalara bağımlı olmamalıdır.
4. Yeniden kullanılabilir bileşenler `component` klasöründe oluşturulmalıdır.
5. Veri modelleri için factory metodları kullanılmalıdır.

## Hata Ayıklama

Uygulama geliştirme sırasında karşılaşılabilecek sorunlar ve çözümleri:

- **Ses Çalınmıyor**: Android için gerekli izinlerin AndroidManifest.xml dosyasında tanımlandığından emin olun.
- **UI Güncellenmiyor**: PlayerService bildirimlerinin doğru şekilde tetiklendiğinden emin olun.
- **Oynatıcı Kontrolü Sorunları**: Animasyon kontrolcüsü ve oynatıcı durumunun senkronize olduğundan emin olun.

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylı bilgi için [LICENSE](LICENSE) dosyasına bakınız.
