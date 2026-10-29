import 'package:jaspr_site/d/d_markup.dart';
import 'package:jaspr_site/d/d_project.dart';
import 'package:jaspr_site/data/projects_repository.dart';
import 'package:test/test.dart';

DProject project(Map<String, dynamic> json, [String slug = 'app']) => DProject(ProjectItem.fromJson({'title': 'App', 'description': 'An app.', 'tech': <String>[], 'downloads': '', ...json}), slug);

Map<String, dynamic> screens(List<List<Object>> notesPerScreen, {String mode = 'screens'}) => {
  'mode': mode,
  'screens': [
    for (final (i, notes) in notesPerScreen.indexed)
      {
        'url': 'https://img.test/$i.webp',
        'caption': 'Screen $i',
        'notes': [for (final n in notes) {'label': (n as List)[0], 'y': n[1]}],
      },
  ],
};

void main() {
  group('the new Firestore fields', () {
    test('showcase and store listings parse; bad entries are dropped, y is clamped', () {
      final item = ProjectItem.fromJson({
        'title': 'Stock Mobile App',
        'showcase': {
          'mode': 'screens',
          'screens': [
            {'url': 'https://img.test/a.webp', 'caption': 'Home', 'notes': [{'label': 'CartBar', 'y': 140}, {'label': '', 'y': 10}, {'y': 3}]},
            {'caption': 'no url'},
            'not a map',
          ],
        },
        'storeListings': [
          {'store': 'play', 'title': 'Stock', 'developer': 'Stock Developer', 'iconUrl': 'https://img.test/i.webp'},
          {'store': 'huawei', 'title': 'x'},
        ],
      });
      expect(item.showcase.mode, ShowcaseMode.screens);
      expect(item.showcase.screens, hasLength(1));
      expect(item.showcase.screens.single.notes.single.label, 'CartBar');
      expect(item.showcase.screens.single.notes.single.y, 100);
      expect(item.storeListings.single.developer, 'Stock Developer');
      expect(item.listing('ios'), isNull);
    });

    test('a project without the fields still works (empty showcase)', () {
      final item = ProjectItem.fromJson({'title': 'Old'});
      expect(item.showcase.mode, isNull);
      expect(item.showcase.screens, isEmpty);
      expect(item.storeListings, isEmpty);
    });
  });

  group('what a project shows', () {
    test('name, downloads or status, platforms', () {
      final stock = project({'title': 'Stock Mobile App', 'downloads': '10,000+', 'androidStoreUrl': 'https://play', 'iosStoreUrl': 'https://ios'});
      expect(stock.name, 'Stock');
      expect(stock.downloads, 10000);
      expect(stock.status, isNull);
      expect(stock.platforms, 'Android · iOS');
      // The dashboard takes free text: the plus may come first.
      final damany = project({'title': 'Damany', 'downloads': '+50'});
      expect(damany.downloads, 50);
      expect(damany.status, isNull);
      final drugza = project({'title': 'DrugZa - TagPharma', 'downloads': 'Active Development'});
      expect(drugza.name, 'DrugZa');
      expect(drugza.downloads, isNull);
      expect(drugza.status, 'Active Development');
      expect(drugza.platforms, '');
    });

    test('without a chosen showcase: the gallery shows, or the video when there is no gallery', () {
      expect(project({'galleryImages': ['https://img.test/1.png']}).screens.single.caption, 'Screen 1');
      expect(project({'videoUrl': '/v.mp4'}).mode, ShowcaseMode.video);
    });
  });

  group('markup', () {
    test('Firestore text is escaped', () {
      final html = dProjects([project({'title': '<b>x</b>', 'description': 'a & "b"', 'showcase': screens([[]])})]);
      expect(html, isNot(contains('<b>x</b>')));
      expect(html, contains('&lt;b&gt;x&lt;/b&gt;'));
      expect(html, contains('a &amp; &quot;b&quot;'));
    });

    test('the iPhone shows only for an app on the App Store; Android only for one on Google Play', () {
      final both = dProjects([project({'androidStoreUrl': 'https://play', 'iosStoreUrl': 'https://ios', 'showcase': screens([[], []])})]);
      expect(both, contains('data-swap'));
      expect(both, contains('>Android</span>'));
      final none = dProjects([project({'showcase': screens([[], []])})]);
      expect(none, isNot(contains('data-swap')));
      expect(none, isNot(contains('>Android</span>')));
      expect(none, contains('>preview</span>'));
    });

    test('artwork makes no device claim; video plays the recording', () {
      final art = dProjects([project({'androidStoreUrl': 'https://play', 'showcase': screens([[], []], mode: 'art')})]);
      expect(art, contains('store artwork'));
      expect(art, isNot(contains('>Android</span>')));
      final video = dProjects([project({'videoUrl': '/v.mp4', 'showcase': {'mode': 'video'}})]);
      expect(video, contains('<video class="frame on" src="/v.mp4"'));
    });

    test('a store link without listing data still gets its preview, with no guessed developer', () {
      final html = dProjects([project({'title': 'Damany', 'androidStoreUrl': 'https://play', 'showcase': screens([[], []])})]);
      expect(html, contains('class="peek"'));
      expect(html, contains('<b dir="auto">Damany</b></span>'));
      expect(html, isNot(contains('<small>')));
      expect(html, contains('View on Google Play'));
    });

    test('up to 8 screens show as dashes; more get the pager with the first screen named', () {
      final eight = dProjects([project({'showcase': screens(List.filled(8, []))})]);
      expect(eight, contains('class="steps"'));
      expect(eight, isNot(contains('class="pager"')));
      final many = dProjects([project({'showcase': screens(List.filled(16, []))})]);
      expect(many, isNot(contains('class="steps"')));
      expect(many, contains('<b dir="auto">Screen 0</b><span>1/16</span>'));
      expect(many, contains('data-caption="Screen 15"'));
    });

    test('inspector labels travel with each screen', () {
      final html = dProjects([project({'showcase': screens([[['SearchAppBar', 13], ['CartBar', 93]]])})]);
      expect(html, contains('data-notes="SearchAppBar@13|CartBar@93"'));
    });

    test('the hero shows a real project: its first screen and the widgets on it', () {
      final stock = project({'title': 'Stock Mobile App', 'downloads': '10,000+', 'tech': ['Bloc'], 'androidStoreUrl': 'https://play', 'showcase': screens([[['SearchAppBar', 13], ['CategoryGrid', 55], ['CartBar', 93]]])});
      final art = project({'title': 'Gomla', 'downloads': '10,000+', 'showcase': screens([[], []], mode: 'art')});
      expect(heroProject([art, stock]), same(stock));
      final html = dHero(scene: heroProject([art, stock]), location: 'Cairo, Egypt');
      expect(html, contains('src="https://img.test/0.webp"'));
      for (final w in ['SearchAppBar', 'CategoryGrid', 'CartBar']) {
        expect(html, contains('<span>$w</span>'), reason: 'widget box');
        expect(html, contains('<span class="t">$w</span>'), reason: 'code');
      }
      expect(html, contains('Stock on Google Play<b>10,000+ downloads</b>'));
      expect(heroProject([art]), isNull);
    });

    test('a Featured project leads the hero, even with store artwork, and no widgets are made up for it', () {
      final stock = project({'title': 'Stock Mobile App', 'downloads': '10,000+', 'androidStoreUrl': 'https://play', 'showcase': screens([[['SearchAppBar', 13], ['CartBar', 93]]])});
      final gomla = project({'title': 'Gomla', 'featured': true, 'downloads': '10,000+', 'androidStoreUrl': 'https://play', 'showcase': screens([[], []], mode: 'art')});
      expect(heroProject([stock, gomla]), same(gomla));
      final html = dHero(scene: gomla, location: 'Cairo, Egypt');
      expect(html, contains('src="https://img.test/0.webp"'));
      expect(html, contains('Gomla on Google Play<b>10,000+ downloads</b>'));
      expect(html, isNot(contains('class="layer code"')));
      expect(html, isNot(contains('class="box"')));
      // Without a Featured project the hero keeps choosing labelled screens.
      expect(heroProject([project({'title': 'Gomla', 'showcase': screens([[]], mode: 'art')}), stock]), same(stock));
    });

    test('a case study shows the story only when the owner wrote it', () {
      final p = project({'problem': 'Orders were slow.', 'showcase': screens([[]])});
      expect(dCaseStudy(p, prev: null, next: null), contains('<dt>problem</dt><dd dir="auto">Orders were slow.</dd>'));
      expect(dCaseStudy(project({'showcase': screens([[]])}), prev: null, next: null), isNot(contains('id="story"')));
    });
  });
}
